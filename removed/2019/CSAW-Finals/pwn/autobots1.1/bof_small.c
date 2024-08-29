#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <stdio.h>
#include <string.h>

int main() {{
    int listen_fd, comm_fd;
    struct sockaddr_in servaddr;
    listen_fd = socket(AF_INET, SOCK_STREAM, 0);
    memset(&servaddr, 0, sizeof(servaddr));
    servaddr.sin_family = AF_INET;
    servaddr.sin_addr.s_addr = htons(INADDR_ANY);
    servaddr.sin_port = htons({port});
    int b = bind(listen_fd, (struct sockaddr *) &servaddr, sizeof(servaddr));
    if (b == -1)
        exit(0);


    int l = listen(listen_fd, 10);
    if (l == -1)
        exit(0);

    comm_fd = accept(listen_fd, (struct sockaddr*) NULL, NULL);


    char buf[{buf_size_low}];
    read(comm_fd, buf, {read_len_low});
    write(comm_fd, buf, strlen(buf)+1);
    return 0;
}}
