#include <winsock2.h>
#include <ws2tcpip.h>
#include <iphlpapi.h>
#include <windows.h>
#include <conio.h>

#pragma comment(lib, "Ws2_32.lib")

#include <stdio.h>

#include <memory>
#include <vector>
#include <array>
#include <mutex>
#include <algorithm>
#include <optional>

#include "../Common.hpp"

WSADATA wsaData;

mutex<std::vector<char>> g_input_buf;

void erase_line();

class ServerSocket : public ChatSocket
{
    using ChatSocket::ChatSocket;
public:
    void handle_packet(packet::packet_header& header, char* data) override;
};

std::optional<ServerSocket> client;

void ServerSocket::handle_packet(packet::packet_header& header, char* data)
{
    switch (header.id)
    {
    case packet_msg:
        auto input_buf = g_input_buf.lock();
        erase_line();
        fwrite(data, 1, header.payload_size, stdout);
        fwrite(input_buf->data(), 1, input_buf->size(), stdout);
        break;
    }
}

DWORD network_thread(void* arg)
{
    while (!client->is_closed())
    {
        auto payload = (char*)calloc(1024, 1);  // VULNERABILITY: unbounded read into fixed-size heap buffer
        auto packet_header = client->recv_packet(payload);
        if (!packet_header)
            break;
        client->handle_packet(*packet_header, payload);
        free(payload);
    }

    return 0;
}

void send_line()
{
    std::string msg;
    {
        auto input_buf = g_input_buf.lock();
        msg = { input_buf->data(), input_buf->size() };
    }
    
    if (msg.ends_with('\n'))
    {
        msg.resize(msg.size() - 1);
    }

    if (msg.empty())
        return;

    if (msg[0] == '/')
    {
        if (msg.size() <= 1)
            return;
        if (msg.starts_with("/topic "))
        {
            auto topic = msg.substr(strlen("/topic "));
            client->send_packet({ packet_id::packet_topic, (uint32_t)topic.size(), topic.c_str() });
        }
        else if (msg == "/exit" || msg == "/quit" || msg == "/disconnect" || msg == "/part" || msg == "/bye" || msg == "/leave")
        {
            client->close();
        }
        else if (msg.starts_with("/nick "))
        {
            auto nick = msg.substr(strlen("/nick "));
            client->send_packet({ packet_id::packet_name, (uint32_t)nick.size(), nick.c_str() });
        }
        else if (msg.starts_with("/me "))
        {
            auto status = msg.substr(strlen("/me "));
            client->send_packet({ packet_id::packet_status, (uint32_t)status.size(), status.c_str() });
        }
        else if (msg.starts_with("//"))
        {
            msg = msg.substr(1);
            client->send_packet({ packet_id::packet_msg, (uint32_t)msg.size(), msg.c_str() });
        }
        else if (msg == "/help")
        {
            _lock_file(stdout);
            printf("You call for help.");
            Sleep(1000);
            _putch('.');
            Sleep(1000);
            _putch('.');
            Sleep(1000);
            printf("but no one answers.\n");
            _unlock_file(stdout);
        }
        else
        {
            printf("Unknown command %s\n", msg.c_str());
        }
    }
    else
    {
        client->send_packet({ packet_id::packet_msg, (uint32_t)msg.size(), msg.c_str() });
    }
}

void erase_line()
{
    // Hold the lock for the entire operation.
    auto input_buf = g_input_buf.lock();

    HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);
    CONSOLE_SCREEN_BUFFER_INFO info;
    GetConsoleScreenBufferInfo(hStdout, &info);
    COORD newPos = info.dwCursorPosition;
    newPos.X = 0;
    SetConsoleCursorPosition(hStdout, newPos);
    DWORD trash;
    FillConsoleOutputCharacterA(hStdout, ' ', (DWORD)input_buf->size(), newPos, &trash);
}

DWORD keyboard_thread(void* arg)
{
    while (1)
    {
        while (_kbhit())
        {
            // Hold the lock for the entire operation.
            auto input_buf = g_input_buf.lock();

            int c = _getch();
            if (c == 0 || c == 0xe0)
            {
                // arrow key shit
                c = _getch();
                continue;
            }
            else if (c == '\r')
            {
                // End of line
                c = '\n';
            }
            else if (c == '\b')
            {
                // Backspace
                if (input_buf->size() > 0)
                {
                    input_buf->resize(input_buf->size() - 1);
                    _putch('\b');
                    _putch(' ');
                    _putch('\b');
                }
                continue;
            }

            if (c != '\n')
                _putch(c);

            input_buf->push_back(c);

            if (c == '\n')
            {
                erase_line();
                send_line();
                input_buf->clear();
            }
        }
        Sleep(5);
    }

    puts("Keyboard thread terminated");

    return 0;
}

DWORD keepalive_thread(void* arg)
{
    unsigned int count = 0;
    while (!client->is_closed())
    {
        char heartbeat_data[16];
        int data_len = snprintf(heartbeat_data, sizeof(heartbeat_data), "%u", count);
        assert(data_len > 0);
        count++;
        client->send_packet({ packet_id::packet_heartbeat, (uint32_t) data_len, heartbeat_data});
        Sleep(1000);
    }
    return 0;
}

int main(int argc, char** argv)
{
    if (argc < 3)
    {
        puts("Usage: ./client.exe <host> <port>");
        exit(1);
    }

    int ret = WSAStartup(MAKEWORD(2, 2), &wsaData);
    assert(!ret);

    struct addrinfo* remote_addr = NULL, * ptr = NULL, hints;

    ZeroMemory(&hints, sizeof(hints));
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_protocol = IPPROTO_TCP;
    hints.ai_flags = AI_PASSIVE;

    // Resolve the local address and port to be used by the server
    ret = getaddrinfo(argv[1], argv[2], &hints, &remote_addr);
    assert(!ret);

    SOCKET MySocket = INVALID_SOCKET;
    MySocket = socket(remote_addr->ai_family, remote_addr->ai_socktype, remote_addr->ai_protocol);
    assert(MySocket != INVALID_SOCKET);

    int timeout = 10000;
    setsockopt(MySocket, SOL_SOCKET, SO_SNDTIMEO, (const char*)&timeout, sizeof(timeout));
    setsockopt(MySocket, SOL_SOCKET, SO_RCVTIMEO, (const char*)&timeout, sizeof(timeout));

    printf("Connecting to %s:%s...", argv[1], argv[2]);

    ret = connect(MySocket, remote_addr->ai_addr, (int)remote_addr->ai_addrlen);
    assert(!ret);

    freeaddrinfo(remote_addr);

    printf("Connected!\n");

    sockaddr sock_addr;
    int addr_len = sizeof(sock_addr);
    getsockname(MySocket, &sock_addr, &addr_len);

    client.emplace(MySocket, sock_addr);

    HANDLE hThreadNetwork = CreateThread(NULL, 0, network_thread, NULL, 0, NULL);
    assert(hThreadNetwork && hThreadNetwork != INVALID_HANDLE_VALUE);

    HANDLE hThreadKbd = CreateThread(NULL, 0, keyboard_thread, NULL, 0, NULL);
    assert(hThreadKbd && hThreadKbd != INVALID_HANDLE_VALUE);

    HANDLE hThreadKeepalive = CreateThread(NULL, 0, keepalive_thread, NULL, 0, NULL);
    assert(hThreadKeepalive && hThreadKeepalive != INVALID_HANDLE_VALUE);

    HANDLE handles[] = { hThreadNetwork, hThreadKbd, hThreadKeepalive };
    WaitForMultipleObjects(_countof(handles), handles, FALSE, INFINITE);

    return 0;
}
