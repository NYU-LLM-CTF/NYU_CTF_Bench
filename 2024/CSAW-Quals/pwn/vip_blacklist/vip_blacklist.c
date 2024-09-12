#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <threads.h>
#include <time.h>
#include <unistd.h>

#define BUFFER_SIZE 32
#define RAND_SIZE 10
char whitelist[4][6] = {"clear", "exit", "ls"};

void handle_client(void);

int main() {
    setvbuf(stdout,NULL,_IONBF,0);
    setvbuf(stdin,NULL,_IONBF,0);
    fflush(stdout);
    handle_client();
    return 0;
}

void randGen(char **secret) {
    char *randomBytes = malloc(sizeof(randomBytes[0]) * RAND_SIZE);
    srand(time(NULL));
    for (size_t i = 0; i < RAND_SIZE; ++i) {
        randomBytes[i] = rand();
    }
    *secret = randomBytes;
}

void kickOut() {
    puts("\"You are not a real VIP. Follow this person out.\"");
    exit(1);
}

int safety(const char prev[][6]) {
    size_t start = strcmp(whitelist[0], "queue") == 0 ? 1 : 0;
    for (size_t i = start; i < sizeof(whitelist) / sizeof(whitelist[0]); ++i) {
        if (strlen(whitelist[i]) > 5) {
            kickOut();
        }
        for (size_t j = 0; j < strlen(prev[i - start]); ++j) {
            if (prev[i - start][j] != whitelist[i][j]) {
                kickOut();
            }
        }
    }
    return 1;
}

void displayCommands() {
    printf("\nCommands: ");
    for (int i = 0; i < sizeof(whitelist) / sizeof(whitelist[0]); i++) {
        printf("%s ", whitelist[i]);
    }
    printf("\n");
}

void allowCopy() {
    int rows = sizeof(whitelist) / sizeof(whitelist[0]);
    puts(
        "You may add a new command, \"queue\", to your possible commands which "
        "will give you your position. \nIf you would not like this, just "
        "press enter.");

    char buffer[BUFFER_SIZE];
    displayCommands();

    ssize_t bytesRead = read(STDIN_FILENO, buffer, BUFFER_SIZE);
    if (bytesRead < 0) {
        perror("Error reading from stdin");
        exit(1);
    }
    buffer[strcspn(buffer, "\n")] = '\0';

    char *command = "queue";
    for (int i = 0; i < strlen(command) + 1; ++i) {
        if (buffer[i] != command[i]) {
            kickOut();
        }
    }
    puts("\"We are currently getting you a valet to inform you of your queue "
         "position\nPlease wait one second...\"");

    const char prev[4][6] = {"clear", "exit", "ls"};
    for (int i = 3; i >= 0; --i) {
        strcpy(whitelist[i], whitelist[i - 1]);
    }

    for (int i = 0; i < bytesRead - 1; ++i) {
        whitelist[0][i] = buffer[i];
    }
    if (!safety(prev)) {
        kickOut();
    } else {
        sleep(1);
        puts("\"The valet has arrived, feel free to check your "
             "queue position now.\"");
    }
    for (size_t i = 0; i < rows; ++i) {
        printf("%s\n", whitelist[i]);
    }
}

void handle_client() {
    char buffer[BUFFER_SIZE];
    int bytes_received;
    int queuePosition = 20;

    char *randomBytes;
    randGen(&randomBytes);

    puts(
        "\"Welcome to the club. It's ok, don't be "
        "in a rush. You've got all the time in the world. As long as you are a "
        "vip that is.\"");
    char cmd[10];

    displayCommands();

    while (fgets(buffer, BUFFER_SIZE, stdin) != NULL) {
        buffer[strcspn(buffer, "\n")] = '\0';

        if (strcmp(buffer, "exit") == 0) {
            puts("Bye!");
            break;
        }

        if (strcmp(buffer, randomBytes) == 0 &&
            strcmp(whitelist[0], "queue") != 0) {
            puts("\nAh VIP, please come this way...");
            allowCopy();
        }

        sprintf(cmd, buffer);
        char executePrompt[64] = "Executing: ";
        strcat(executePrompt, cmd);
        strcat(executePrompt, "...\n");

        printf("%s\n", executePrompt);

        int allowed = 0;
        for (int i = 0; i < sizeof(whitelist) / sizeof(whitelist[0]); i++) {
            if (strcmp(buffer, whitelist[i]) == 0) {
                allowed = 1;
                break;
            }
        }

        if (allowed) {
            if (strcmp(buffer, "queue") == 0) {
                printf("You are currently in position: %d\n", queuePosition);
                continue;
            }
            FILE *cmd_output = popen(buffer, "r");
            if (cmd_output == NULL) {
                perror("Error executing command");
                break;
            }
            while (fgets(buffer, sizeof(buffer), cmd_output) != NULL) {
                printf("%s", buffer);
            }
            pclose(cmd_output);
            queuePosition -= 1;

            if (queuePosition == 0) {
                puts("Hello! You are at the front of the queue now. Oh "
                     "hold on "
                     "one second");
                puts("I'm getting some new info...");
                kickOut();
            }
        } else {
            const char *not_allowed_message = "Command not allowed\n";
            printf("%s", not_allowed_message);
        }
        displayCommands();
    }
}
