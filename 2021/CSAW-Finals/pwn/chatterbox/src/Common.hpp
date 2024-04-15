#pragma once

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

#define assert(what) { if (!(what)) { abort(); } }

template <typename T, typename M = std::recursive_mutex>
class mutex
{
    template <typename T, typename M>
    class locked_ptr
    {
        T* ptr;
        M* lock;

        locked_ptr(locked_ptr<T, M> const& ptr) = delete;
        locked_ptr& operator= (locked_ptr<T, M> const& ptr) = delete;

    public:
        locked_ptr(T* ptr, M* lock) : ptr(ptr), lock(lock)
        {
            lock->lock();
        }

        ~locked_ptr()
        {
            unlock();
        }

        locked_ptr(locked_ptr<T, M>&& other) : ptr(other.ptr), lock(other.lock)
        {
            other.ptr = nullptr;
            other.lock = nullptr;
        }

        T* operator ->() { return ptr; }

        T const* operator ->() const { return ptr; }

        void unlock()
        {
            if (lock)
            {
                lock->unlock();
                lock = nullptr;
                ptr = nullptr;
            }
        }
    };

    T data;
    M _lock;

    mutex(mutex<T, M> const& ptr) = delete;
    mutex& operator= (mutex<T, M> const& ptr) = delete;

public:
    template<typename... TT>
    mutex(TT&&... args) : data(std::forward<TT>(args)...) {}

    mutex(T&& data) : data(data) {}

    auto lock()
    {
        return locked_ptr<T, M>(&data, &_lock);
    }
};

enum packet_id
{
    packet_msg = 1,
    packet_heartbeat = 2,
    packet_topic = 3,
    packet_name = 4,
    packet_status = 5,
};

struct packet
{
    struct packet_header
    {
        packet_id id;
        uint32_t payload_size;
    } header;
    const char* data;

    packet(packet_id id, uint32_t payload_size, const char* data) : header{id, payload_size}, data(data)
    {
        assert(id > 0);
    }
};

class ChatSocket
{
    SOCKET socket;
    sockaddr addr;
    bool closed;

    std::recursive_mutex recv_lock, send_lock;

    ChatSocket() = delete;
    ChatSocket(ChatSocket const& ptr) = delete;
    ChatSocket& operator= (ChatSocket const& ptr) = delete;

public:
    ChatSocket(SOCKET socket, sockaddr addr) : socket(socket), addr(addr), closed(false)
    {
        assert(socket != INVALID_SOCKET);
    }

    ~ChatSocket()
    {
        auto inet_addr = reinterpret_cast<sockaddr_in*>(&addr);
        close();
    }

    ChatSocket(ChatSocket&& other) noexcept : socket(other.socket), addr(other.addr), closed(other.closed)
    {
        other.socket = INVALID_SOCKET;
        other.closed = true;
    }

    void close()
    {
        if (!closed && socket != INVALID_SOCKET)
        {
            closed = true;
            closesocket(socket);
            socket = INVALID_SOCKET;
        }
    }

    bool is_closed()
    {
        return closed;
    }

    int recvn(char* buf, int n)
    {
        const std::lock_guard<std::recursive_mutex> lock(recv_lock);

        assert(!closed);

        int received = 0;
        while (received < n && !closed)
        {
            int result = ::recv(socket, buf + received, n - received, 0);
            if (result < 0)
            {
                puts("recv: Socket closed");
                close();
                return -1;
            }
            else if (result == 0)
            {
                puts("recv: EOF");
                break;
            }
            else
            {
                received += result;
            }
        }
        return received;
    }

    int send(const char* buf, int n)
    {
        const std::lock_guard<std::recursive_mutex> lock(send_lock);

        int sent = 0;
        while (sent < n && !closed)
        {
            int result = ::send(socket, buf + sent, n - sent, 0);
            if (result < 0)
            {
                puts("send: Socket closed");
                close();
                return -1;
            }
            else if (result == 0)
            {
                puts("send: EOF");
                break;
            }
            else
            {
                sent += result;
            }
        }
        return sent;
    }

    template <typename T>
    std::optional<T> recv()
    {
        T t;
        int n = recvn(reinterpret_cast<char*>(&t), sizeof(t));
        if (n != sizeof(t))
            return std::optional<T>();
        return t;
    }

    template <typename T>
    bool send(const T& t)
    {
        int result = send(reinterpret_cast<const char*>(&t), sizeof(t));
        return result == sizeof(t);
    }

    // BUG: No bounds or length check.
    std::optional<packet::packet_header> recv_packet(char* out)
    {
        const std::lock_guard<std::recursive_mutex> lock(recv_lock);

        auto header = recv<packet::packet_header>();
        if (!header)
            return std::nullopt;
        // BUG: Result of recvn is not checked, possibility of incomplete read of packet if socket is shutdown in one direction
        recvn(out, header->payload_size);
        return header;
    }

    bool send_packet(const packet& packet)
    {
        const std::lock_guard<std::recursive_mutex> lock(send_lock);

        // Send header
        bool result = send(packet.header);
        if (!result)
            return false;
        bool ok = send(packet.data, packet.header.payload_size) == packet.header.payload_size;
        return ok;
    }

    virtual void handle_packet(packet::packet_header& header, char* data) = 0;
};
