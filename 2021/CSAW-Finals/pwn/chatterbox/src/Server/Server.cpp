#include <winsock2.h>
#include <ws2tcpip.h>
#include <iphlpapi.h>
#include <windows.h>

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

__declspec(align(512)) // Make allocation size == 1024 to put it in same bin as the overflown heap buffer
class ClientSocket : public ChatSocket
{
    std::string name;

    using ChatSocket::ChatSocket;
public:
    void handle_packet(packet::packet_header& header, char* data) override;

    void set_name(std::string name)
    {
        this->name = name;
    }

    auto get_name() const
    {
        return name;
    }

    void send_message(std::string s)
    {
        send_packet({ packet_id::packet_msg, (uint32_t) s.size(), s.c_str() });
    }
};

class ChatChannel
{
    std::vector<std::shared_ptr<ClientSocket>> clients;
    char topic[1024] = { 0 };

public:
    void add_client(std::shared_ptr<ClientSocket> c)
    {
        clients.push_back(c);
        c->send_message("*** Topic is '" + get_topic() + "'\n");
        broadcast_message("* " + c->get_name() + " connected\n");
    }

    void remove_client(const std::shared_ptr<ClientSocket>& c)
    {
        clients.erase(std::remove(clients.begin(), clients.end(), c), clients.end());
        
        broadcast_message("* " + c->get_name() + " has disconnected\n");
    }

    void broadcast_message(const char* msg, size_t len)
    {
        fwrite(msg, 1, len, stdout);
        for (auto& c : clients)
        {
            c->send_message({ msg, (size_t) len});
        }
    }

    void broadcast_message(std::string s)
    {
        broadcast_message(s.c_str(), s.size());
    }

    void set_topic(std::string s)
    {
        size_t len = s.size()+1;
        if (len > sizeof(topic))
            len = sizeof(topic);
        memcpy(topic, s.c_str(), len);
    }

    std::string get_topic() const
    {
        return topic;
    }
};

mutex<ChatChannel> g_server;

void ClientSocket::handle_packet(packet::packet_header& header, char* data)
{
    switch (header.id)
    {
    case packet_msg:
        g_server.lock()->broadcast_message(get_name() + ": " + std::string{ data, header.payload_size } + "\n");
        break;
    case packet_heartbeat:
        // VULNERABILITY: Possible out of bounds read on data
        send_packet({ packet_id::packet_heartbeat, header.payload_size, data });
        break;
    case packet_topic:
    {
        auto s = g_server.lock();
        s->set_topic(std::string(data, header.payload_size).c_str());
        s->broadcast_message("*** Topic is now '" + s->get_topic() + "'\n");
        break;
    }
    case packet_name:
        if (header.payload_size > 0)
        {
            std::string old_name = get_name();
            set_name({ data, header.payload_size });
            g_server.lock()->broadcast_message("* " + old_name + " is now " + get_name() + "\n");
        }
        break;
    case packet_status:
        g_server.lock()->broadcast_message("* " + get_name() + " " + std::string{ data, header.payload_size } + "\n");
        break;
    }
}

DWORD network_thread(void* arg)
{
    auto pClient = static_cast<std::shared_ptr<ClientSocket>*>(arg);
    auto c = *pClient;
    delete pClient;

    while (!c->is_closed())
    {
        // VULNERABILITY: unbounded read into fixed-size heap buffer
        auto payload = (char*)_aligned_malloc(1024, 512); // get this shit to allocate in the same fucking slots as the other shit to make the chal easier
        // printf("payload %p\n", payload);
        auto packet_header = c->recv_packet(payload);
        if (!packet_header)
            break; // BUG: Memory leak, payload is not freed in this case.
        c->handle_packet(*packet_header, payload);
        _aligned_free(payload);
    }

    g_server.lock()->remove_client(c);

    puts("Client thread terminated");

    return 0;
}

char flag[1024];

void read_flag()
{
    FILE* f = fopen("C:\\flag.txt", "r");
    fread(flag, 1, 1024, f);
    fclose(f);
}

int main(int argc, char** argv)
{
    if (argc < 3)
    {
        puts("Usage: ./server.exe <host> <port>");
        exit(1);
    }

    read_flag();

    int ret = WSAStartup(MAKEWORD(2, 2), &wsaData);
    assert(!ret);

    g_server.lock()->set_topic("Check out my awesome new chat application!");

    struct addrinfo* bind_addr = NULL, * ptr = NULL, hints;

    ZeroMemory(&hints, sizeof(hints));
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_protocol = IPPROTO_TCP;
    hints.ai_flags = AI_PASSIVE;

    // Resolve the local address and port to be used by the server
    ret = getaddrinfo(argv[1], argv[2], &hints, &bind_addr);
    assert(!ret);

    SOCKET ListenSocket = INVALID_SOCKET;
    ListenSocket = socket(bind_addr->ai_family, bind_addr->ai_socktype, bind_addr->ai_protocol);
    assert(ListenSocket != INVALID_SOCKET);

    ret = bind(ListenSocket, bind_addr->ai_addr, (int)bind_addr->ai_addrlen);
    assert(!ret);

    freeaddrinfo(bind_addr);

    ret = listen(ListenSocket, SOMAXCONN);
    assert(!ret);

    printf("Listening on %s:%s\n", argv[1], argv[2]);

    while (1)
    {
        SOCKET accepted_socket = INVALID_SOCKET;
        sockaddr client_addr;
        int client_addr_len = sizeof(client_addr);
        accepted_socket = accept(ListenSocket, &client_addr, &client_addr_len);
        if (accepted_socket == INVALID_SOCKET)
        {
            puts("accept() failed");
            abort();
        }

        auto inet_addr = reinterpret_cast<sockaddr_in*>(&client_addr);
        printf("Received connection from %s:%d\n", inet_ntoa(inet_addr->sin_addr), inet_addr->sin_port);

        int timeout = 10000;
        setsockopt(accepted_socket, SOL_SOCKET, SO_SNDTIMEO, (const char*)&timeout, sizeof(timeout));
        //setsockopt(ClientSocket, SOL_SOCKET, SO_RCVTIMEO, (const char*)&timeout, sizeof(timeout));

        auto c = std::make_shared<ClientSocket>(accepted_socket, client_addr);
        // printf("client %p\n", c.get());

        char name[100];
        snprintf(name, sizeof(name), "UnnamedChatter%u", rand());
        c->set_name(name);

        g_server.lock()->add_client(c);
        HANDLE hThread = CreateThread(NULL, 0, network_thread, new std::shared_ptr<ClientSocket>(std::move(c)), 0, NULL);
        assert(hThread && hThread != INVALID_HANDLE_VALUE);
        CloseHandle(hThread);
    }
}
