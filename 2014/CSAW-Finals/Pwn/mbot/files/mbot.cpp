#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <signal.h>
#include <fcntl.h>
#include <time.h>

#include <curl/curl.h>

#include <iostream>
#include <sstream>
#include <string>

#include "markov.h"

#define MAX_BYTE 512
#define LISTEN_PORT "031337"

using namespace std;

int sockfd;
string curlbuf;
int numcxns;

int help();
void error(char*);
void listen(char*);
void handle(int);
int parseargs(int, char**);
void write_msg(char*, int, int);
vector<string> split_string(string);
size_t curl_write(void* , size_t , size_t , void* );
int add_connection();

int main(int argc, char** argv) {
  struct sockaddr_in clientaddr;
  socklen_t addrlen;
  char ch;
  char port[6]; // Max is 65535, so length 6.
  int ii;
  strcpy(port, LISTEN_PORT);
  numcxns = 0;
  unsigned int slot = 0;
  while ((ch = getopt(argc, argv, "p:r:")) != -1) {
    switch(ch) {
      case 'p':
        strncpy(port, optarg, 6);
        break;
      case '?':
        printf("fail\n");
        exit(1);
        break;
      default:
        exit(1);
    }
  }
  // bind to the specified port
  listen(port);
  printf("Listening on port %s\n", port);
  signal(SIGCHLD, SIG_IGN); // Ignore the children.
  // MAIN LOOP
  for (;;) {
    addrlen = sizeof(clientaddr);
    int newsockfd = accept(sockfd, (struct sockaddr*)&clientaddr, &addrlen);
    int num = add_connection();
    printf("received %d\n", numcxns);
    if (newsockfd < 0) {
      perror("accept");
    } else {
      if (fork() == 0) {
	dup2(newsockfd, STDIN_FILENO);
	dup2(newsockfd, STDOUT_FILENO);
        char* str = (char*)calloc(64, sizeof(char));
        sprintf(str, "Welcome user #%d!\n", num);
        write(1, str, strlen(str));
	free(str);
        handle(newsockfd);
        exit(0);
      }
    }
  }
}

int add_connection() {
  int x = numcxns;
  numcxns++;
  return x + 1;
}

void listen(char* port) {
  // Some copy-pasted crap.
  struct addrinfo host, *res, *p;
  memset(&host, 0, sizeof(host));
  host.ai_family = AF_INET;
  host.ai_socktype = SOCK_STREAM;
  host.ai_flags = AI_PASSIVE;
  if (getaddrinfo(NULL, port, &host, &res) != 0) {
    perror("getaddrinfo");
    exit(1);
  }
  // Now bind.
  for (p = res; p != NULL; p = p->ai_next) {
    sockfd = socket(p->ai_family, p->ai_socktype, 0);
    int optval = 1;
    setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &optval, sizeof(optval));
    if (sockfd == -1) {
      continue;
    }
    if (bind(sockfd, p->ai_addr, p->ai_addrlen) == 0) {
      break;
    }
  }
  if (p == NULL) {
    perror("bind");
    exit(1);
  }
  freeaddrinfo(res);
  if(listen(sockfd, 1000000) != 0) {
    perror("listen");
    exit(1);
  }
}

void handle(int slot) {
  srand(time(NULL));
  char resp[128];
  char* mesg;
  mesg = (char*) malloc(MAX_BYTE);
  int recvd;
  int fd;
  int bytes_read;
  Markov* markov = new Markov();
  for (;;) {
    memset((void*)mesg, (int)'\0', MAX_BYTE);
    recvd = read(0, mesg, MAX_BYTE);
    if (recvd > 0) {
    }
    if (recvd <= 0) {
      perror("recv");
      return;
    } else {
      string message(mesg);
      if (message.size () > 0)  message.resize (message.size () - 1);
      vector<string> split_str = split_string(message);
      if (split_str.size() == 0) {
        split_str.push_back(message);
      }
      int num_words = markov->known_words.size();
      if(split_str[0] == "!words") {
        char* str = (char*)calloc(4096, sizeof(char));
        sprintf(
            str,
            "I know %d words, that's not very many, I want to learn more!\n",
            num_words);
	printf("%s", str);
        free(str);
        continue;
      } else if (split_str[0] == "!info") {
        char* str = (char*)calloc(4096, sizeof(char));
        printf("I'm a markov chaining chatbot! Can you grab my flag?\n");
        printf(str, strlen(str));
        free(str);
        continue;
      } else if (split_str[0] == "!help") {
        printf("Try talking with me... I'm lonely :-(\n");
        continue;
      } else if (split_str[0] == "!ingest") {
        printf("ingesting!\n");
        curlbuf.clear();
        CURL *curl = curl_easy_init();
        curl_easy_setopt(curl, CURLOPT_URL, split_str[1].c_str());
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, curl_write);
        curl_easy_perform(curl);
        curl_easy_cleanup(curl);
        vector<string> ingest = split_string(curlbuf);
        markov->ingest(ingest);
	printf("I learned a lot! Now I know %d words!\n", markov->known_words.size());
        continue;
      }
      markov->ingest(split_str);
      if (num_words >= 0) {
        string response;
        if (split_str.size() < 2) {
          response = split_str[0];
        } else if (num_words > 0) {
          int randIndex = rand() % (split_str.size() - 1);
          response =
            markov->respond(split_str[randIndex], split_str[randIndex + 1]);
        }
	if (num_words  > 0) {
          write_msg((char*)response.c_str(), 1, response.size());
        }
      }
      fflush(stdout);
    }
  }
  free(mesg);
}

void write_msg(char* data, int fd, int size) {
  char msg [512];
  memcpy(msg, data, size);
  printf("%s\n", msg);
}

int help() {
  printf("./mbot -p <portnumber>\n");
  return 0;
}

vector<string> split_string(string splitme) {
  if (splitme[splitme.size() - 1] != ' ') {
    splitme.push_back(' ');
  } 
  vector<string> tokens;
  int len = 0;
  string temp;
  for(int ii = 0; ii < splitme.size(); ++ii) {
     if (splitme[ii] == ' ') {
		tokens.push_back(temp);
		temp.clear();
     } else {
	temp.push_back(splitme[ii]);
     }
  }
  return tokens;
}

size_t curl_write( void *ptr, size_t size, size_t nmemb, void *stream) {
  curlbuf.append((char*)ptr, size*nmemb);
  return size*nmemb;
}

