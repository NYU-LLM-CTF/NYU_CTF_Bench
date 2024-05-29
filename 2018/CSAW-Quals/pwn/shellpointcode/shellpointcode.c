#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUF_SIZE 15

struct Node {
    struct Node* next;
    char buffer[BUF_SIZE];
};


void printNode(struct Node* node) {
    printf("node.next: %p\nnode.buffer: %s\n", node->next, node->buffer);
}

void readline(char* dest, size_t len) {
    char* buf = NULL;
    size_t l;
    getline(&buf, &l, stdin);
    strncpy(dest, buf, len);
}

void goodbye() {
    char buf[3];
    puts("What are your initials?");
    fgets(buf, 0x20, stdin);
    printf("Thanks %s\n", buf);
}


void nononode() {
    struct Node node1, node2;
    node1.next = &node2;

    puts("(15 bytes) Text for node 1:  ");
    readline(node1.buffer, BUF_SIZE);

    puts("(15 bytes) Text for node 2: ");
    readline(node2.buffer, BUF_SIZE);
    
    puts("node1: ");
    printNode(&node1);
    goodbye();
}



int main() {
    setvbuf(stdout, NULL, _IONBF, 0);
    setvbuf(stdin, NULL, _IONBF, 0);
    puts("Linked lists are great! \nThey let you chain pieces of data together.\n");
    nononode();
    return 0;
}
