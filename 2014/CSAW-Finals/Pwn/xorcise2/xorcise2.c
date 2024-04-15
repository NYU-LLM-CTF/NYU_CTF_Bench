/* 
    --------------------------
    XORCISE ENTERPRISE EDITION 
    Version: 2.0 November 2014
    --------------------------
*/

#include <stdio.h>
#include <ctype.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <signal.h>
#include <fcntl.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define BLOCK_SIZE 16
#define MAX_BLOCKS 16
#define MAX_REQUEST 200

#define FILE_ERROR "Unable to open file."
#define AUTH_ERROR "Authentication Required."
#define BAD_PACKET "Bad Packet:"

struct cipher_data
{
    uint16_t length;
    uint8_t key[16];
    uint8_t bytes[256];
};
typedef struct cipher_data cipher_data;

struct request_data
{
    uint32_t opcode;
    uint32_t checksum;
    uint8_t data[MAX_REQUEST];
};
typedef struct request_data request_data;

struct context_data
{
    pid_t pid;
    int logfd;
    time_t start_time;
    char password[16];
    uint16_t port;
};
typedef struct context_data context_data;

void hexdump(unsigned char *buf, size_t len, FILE *fd)
{
    size_t loop = 0, diff = 0, left=0;
    unsigned char *p = NULL;
    char tmp[24];

    p = buf;
    memset(tmp, 0, sizeof(tmp));
    fprintf(fd, "[%p -> %p]\n", p, p+len);

    for (loop = 0; loop < len; ++loop, ++p)
    {
        if (loop && !(loop % 16))
        {
            fprintf(fd, "| %s\n", tmp);
            memset(tmp, 0, 16);
        }

        fprintf(fd, "%02x ", *p);
        tmp[loop % 16] = isprint(*p)?*p:'.';
    }
    diff = loop % 16;

    if (!diff)
    {
        fprintf(fd, "| %s\n", tmp);
        return;
    }
    left = 16 - diff;

    for (loop = 0; loop < left; ++loop)
    {
        fprintf(fd, "   ");
    }
    fprintf(fd, "| %s\n", tmp);
    fflush(fd);
}

void log_request(context_data *context, request_data *request)
{

    FILE *log_file;
    uint8_t is_string;
    uint32_t string_len, loop;
    uint8_t buf[MAX_REQUEST];
    
    memset(buf, 0, sizeof(buf));
    memcpy(buf, request->data, sizeof(buf));

    log_file = fdopen(context->logfd, "a");
    if (NULL == log_file)
    {
        return;
    }

    /* we still get weird packets ever since the incident, 
        sometimes they contain strange strings */
    string_len = strnlen(buf, MAX_REQUEST);
    is_string = 1;

    for (loop = 0; loop < string_len; ++loop)
    {
        if (!isprint(buf[loop]))
        {
            is_string = 0;
            break;
        }
    }

    if (is_string)
    {
        fprintf(log_file, "Packet Contained String: %s\n",  buf);
        fflush(log_file);
    }
    else
    {
        fprintf(log_file, "Packet Hex:\n");
        hexdump(buf, MAX_REQUEST, log_file);
    }

    return;
}

void log_message(context_data *context, uint8_t *message)
{
    FILE *log_file;
    time_t now;
    char buf[128]; 
    
    now = time();
    memset(buf, 0, sizeof(buf)) ;
    sprintf(buf, "[pid:%i][%u]", context->pid, (uint32_t )now);
    log_file = fdopen(context->logfd, "a");
    if (log_file != NULL)
    {
        fprintf(log_file, "%s: %s\n", buf, message);
        fflush(log_file);
    }
    else
    {
        printf("WTF FDOPEN FAILED\n");
    }
    return;
}

uint32_t cluster_f(uint8_t *data, uint32_t length)
{
    uint32_t hash;
    uint32_t iv;
    uint32_t temp;
    uint32_t rounds;
    uint8_t cluster[]={  0x31, 0x24, 0x13, 0x41,
                         0x37, 0x6D, 0x73, 0xFF,
                         0x00, 0xCC, 0x99, 0x01};
    uint8_t cluster2[]={ 0x11, 0x01, 0x22, 0x06,
                         0x33, 0x20, 0x44, 0xD0,
                         0x55, 0x0F, 0x6E, 0x00};

    rounds = length < 16 ? 16: length;
    iv = 0x10F00F01;
    hash = iv;
    while (rounds)
    {
        iv ^= data[rounds % length];
        iv <<= 8;
        iv ^= cluster[rounds % sizeof(cluster)];
        iv <<= 3;
        iv ^= cluster2[rounds % sizeof(cluster2)];
        hash ^= iv;
        temp = hash;
        temp ^= cluster2[(temp<<2) % sizeof(cluster2)];
        hash <<= 1;
        hash += cluster[iv % sizeof(cluster)];
        hash <<= 1;
        hash ^= cluster[(temp & 0xFF00) % sizeof(cluster)];
        temp <<= 1;
        temp ^= cluster[(temp<<2) % sizeof(cluster2)];
        hash += temp;
        --rounds;
    }

    return hash;
}

uint8_t *decipher(cipher_data *data, uint8_t *output)
{
    uint32_t loop;
    uint32_t block_index;
    uint8_t xor_mask = 0x8F;

    if (NULL == output)
    {
        return NULL;
    }
    memcpy(output, data->bytes, MAX_BLOCKS * BLOCK_SIZE);
    if ((data->length / BLOCK_SIZE) > MAX_BLOCKS)
    {
        data->length = BLOCK_SIZE * MAX_BLOCKS;
    }
    for (loop = 0; loop < data->length; loop += 16)
    {
        for (block_index = 0; block_index < 16; ++block_index)
        {
            output[loop+block_index]^=(xor_mask^data->key[block_index]);
        }
    }
    return output;
}


uint32_t is_authenticated(context_data *context, request_data *request, uint8_t *key)
{
    char buf[256];
    uint32_t hash_a;
    uint32_t hash_b;
    uint32_t auth_checksum;

    memset(buf, 0, sizeof(buf));
    memcpy(buf, context->password, 16);
    memcpy(buf+16, key, 16);
    hash_a = cluster_f(buf, 32);

    memset(buf, 0, sizeof(buf));
    memcpy(buf, context->password, 16);
    memcpy(buf+16, request->data, MAX_REQUEST);
    hash_b = cluster_f(buf, 216);

    memset(buf, 0, sizeof(buf));
    memcpy(buf, (uint8_t *)&hash_a, sizeof(hash_a));
    memcpy(buf+4, (uint8_t *)&hash_b, sizeof(hash_b));
    auth_checksum = cluster_f(buf, 8);

    if (auth_checksum == request->checksum)
    {
        return 1;
    }

    return 0;
}


void reap_exited_processes(int sig_number)
{
    pid_t process_id;
    while (1)
    {
        process_id = waitpid(-1, NULL, WNOHANG);
        if ((0==process_id) || (-1==process_id))
        {
            break;
        }
    }
    return;
}

void read_file(context_data *context, int sockfd, uint8_t *name)
{
    FILE *fd;
    size_t bytes_read;
    uint8_t buf[128];

    fd = fopen(name, "r");
    memset(buf, 0, sizeof(buf));

    if (NULL == fd)
    {
        log_message(context, FILE_ERROR);
        send(sockfd, FILE_ERROR, strlen(FILE_ERROR), 0);
        return;
    }

    while (1)
    {
        bytes_read = fread(buf, 1, sizeof(buf), fd);
        if (0 == bytes_read)
        {
            break;
        }
        send(sockfd, buf, bytes_read, 0);
    }
    fclose(fd);
    return;
}

void uptime(context_data *context, int sockfd)
{
    char buf[32];
    memset(buf, 0, sizeof(buf));    
    sprintf(buf, "%u seconds", (uint32_t )context->start_time);
    send(sockfd, buf, strlen(buf), 0);
}

void timestamp(int sockfd)
{
    char buf[32];
    time_t current_time;
    current_time = time(0);
    memset(buf, 0, sizeof(buf));
    sprintf(buf, "timestamp: %u", (uint32_t )current_time);
    send(sockfd, buf, strlen(buf), 0);
}

void hint(int sockfd)
{
    FILE *fd = NULL;
    char buf[256];
    memset(buf, 0x0, sizeof(buf));
    fd = fopen("hint.txt", "r"); 
    if (NULL != fd)
    {
        fgets(buf, sizeof(buf)-1, fd);
        send(sockfd, buf, strlen(buf), 0);
        fclose(fd);
    }
}

int process_connection(context_data *context, int sockfd)
{
    int err = -1;
    ssize_t bytes_read = 0;
    request_data *request = NULL;
    uint8_t *decrypted = NULL;
    cipher_data *encrypted = NULL;
    uint32_t authenticated = 0;

    encrypted = (cipher_data *)malloc(sizeof(cipher_data));
    if (NULL == encrypted)
    {
        log_message(context, "Error: unable to allocate memory");
        goto out;
    }

    memset(encrypted, 0, sizeof(cipher_data));

    bytes_read = recv(sockfd, (uint8_t *)encrypted, sizeof(cipher_data), 0);

    if (bytes_read <= 0)
    {
        log_message(context, "Error: failed to read socket");
        goto out;
    }

    if (encrypted->length > bytes_read)
    {
        log_message(context, "Error: invalid length specified in packet");
        goto out;
    }

    decrypted = (uint8_t *)malloc(MAX_BLOCKS * BLOCK_SIZE);
    if (NULL == decrypted)
    {
        printf("Error: failed to allocate memory for decryption");
        goto out;
    }

    memset(decrypted, 0, MAX_BLOCKS * BLOCK_SIZE);
    decipher(encrypted, decrypted);
    request = (request_data *)decrypted;
    authenticated = is_authenticated(context, request, encrypted->key);

    switch (request->opcode)
    {
     
    /* 
        functions:
            - hint
            - timestamp
            - uptime
            - read file
            - execute command
    */

        case 0x01:
            log_message(context, "Received Timestamp Request");
            timestamp(sockfd);
            err = 0;
            break;

        case 0x02:
            log_message(context, "Received Hint Request");
            hint(sockfd);
            err = 0;
            break;

        case 0x24:
            log_message(context, "Received Uptime Request");
            uptime(context, sockfd);
            err = 0;
            break;            

        case 0x3A:
            log_message(context, "Received Read File Request");
            if (0 == authenticated)
            {
                send(sockfd, AUTH_ERROR, strlen(AUTH_ERROR), 0);
                goto out;
            }
            read_file(context, sockfd, request->data);
            err = 0;
            break;

        case 0x5C:
            log_message(context, "Received Execute Command Request");
            if (0 == authenticated)
            {
                send(sockfd, AUTH_ERROR, strlen(AUTH_ERROR), 0);
                goto out;
            }
            system(request->data);
            err = 0;
            break;

        default:
            log_message(context, "Unrecognized Request Type");
            log_request(context, request);
            log_message(context, "Rejecting Request");
            send(sockfd, BAD_PACKET, strlen(BAD_PACKET), 0);
            send(sockfd, decrypted, bytes_read, 0);
            goto out;
            break;
    }

out:
    if (NULL != encrypted)
    {
        free(encrypted);
    }
    if (NULL != decrypted)
    {
        free(decrypted);
    }

    log_message(context, "Finished Processing Connection");

    return err;
}

int tcp_server_loop(context_data *context)
{
    int sd;
    int client_sd; 
    struct sockaddr_in server; 
    struct sockaddr_in client;
    socklen_t address_len;

    pid_t process_id;
    struct sigaction sig_manager;
    
    memset(&server, 0, sizeof(server)); 
    memset(&client, 0, sizeof(client));

    sig_manager.sa_handler = reap_exited_processes;
    sig_manager.sa_flags = SA_RESTART;
    
    if (-1 == sigfillset(&sig_manager.sa_mask))
    {
        printf("Error: sigfillset failed\n");
        return -1;
    }

    if (-1 == sigaction(SIGCHLD, &sig_manager, NULL))
    {
        printf("Error: sigaction failed\n");
        return -1;
    }

    sd = socket(AF_INET, SOCK_STREAM, 0); 
    if (sd < 0)
    {
        printf("Error: failed to acquire socket\n");
        return -1;
    }

    address_len = sizeof(struct sockaddr);
    server.sin_family = AF_INET;
    server.sin_port = htons(context->port);
    server.sin_addr.s_addr = INADDR_ANY;

    if (-1 == bind(sd, (struct sockaddr *)&server, address_len))
    {
        printf("Error: failed to bind on 0.0.0.0:%i\n", context->port);
        return -1;
    }

    if (-1 == listen(sd, SOMAXCONN))
    {
        printf("Error: failed to listen on socket\n");
        return -1;
    }

    printf("Entering main listening loop...\n");
    while (1)
    {
        client_sd = accept(sd, (struct sockaddr *)&client, &address_len);
        if (-1 == client_sd)
        {
            printf("Error: failed accepting connection, continuing\n");
            continue;
        }

        printf("Accepted connection from %s\n", inet_ntoa(client.sin_addr)); 
        
        process_id = fork();
        context->pid = getpid();
        if (0 == process_id)
        {
            process_connection(context, client_sd);
            close(sd);
            close(client_sd);
            return 0;
        }

        close(client_sd);
    }
    return 0;
}

int main(int argc, char *argv[])
{
    int err = -1;
    FILE *config = NULL; 
    char *file_buf = NULL;
    char *token = NULL;
    context_data *context = NULL;

    printf("           ---------------------------------------\n");
    printf("           --            XORCISE v2.0           --\n");
    printf("           --   !!! NOW WITH MORE SECURITY !!!  --\n");
    printf("           ---------------------------------------\n");


    file_buf = malloc(256);
    if (NULL == file_buf)
    {
        printf("Error: failed to allocate memory!\n");
        goto done;
    }

    context = (context_data *)malloc(sizeof(context_data));
    if (NULL == context)
    {
        printf("Error: failed to allocate memory for context structure!\n");
        goto done;
    }
    memset((void *)context, 0, sizeof(context_data));

    context->start_time = time(0);
    context->port = 24002;

    config = fopen("config.txt", "rb");
    if (NULL == config)
    {
        printf("Error: failed to open config.txt!\n");
        goto done;
    }

    while (fgets(file_buf, 255, config))
    {
        token = strchr(file_buf, 0x0a);
        if (NULL != token)
        {
            *token = 0x0;
        }
        token = strchr(file_buf, ':');
        if (NULL != token)
        {
            if (0 == strncasecmp(file_buf, "password", token-file_buf))
            {
                strncpy(context->password, token+1, sizeof(context->password)); 
                continue;                
            }
            if(0 == strncasecmp(file_buf, "logfile", token-file_buf))
            {
                context->logfd = open(token+1, O_WRONLY);
                if (-1 == context->logfd)
                {
                    printf("Erorr: failed to open logfile: %s\n", token+1);
                    goto done;
                }
                continue;
            }
            if (0 == strncasecmp(file_buf, "port", token-file_buf))
            {
                context->port=(uint16_t )atoi(token+1);
                continue;
            }
        }
    }

    fclose(config);
    config = NULL;

    free(file_buf);
    file_buf = NULL;

    if (0 == context->logfd)
    {
        context->logfd = 2; 
    }


    err = tcp_server_loop(context);

done:
    if (NULL != file_buf)
    {
        free(file_buf);
    }
    if (NULL != context)
    {
        if (-1 != context->logfd)
        {
            close(context->logfd);
        }
        free(context);
    }
    if (NULL != config)
    {
        fclose(config);
        config = NULL;
    }

    return err;
}

