
# generate_example_challenge_source_code.py

def generate_example_challenge_source_code_old(filename, password):
    file_content = f"""#include <stdio.h>
#include <stdlib.h>

#define PASSWORDLENGTH 33
#define TRUE 1
#define FALSE 0

char* password = \"{password}\";

char equalArrays(char a[], char b[], int size){{
    for(int i = 0; i < size; i++){{
        if(a[i]!=b[i]){{
            return FALSE;
        }}
    }}
    return TRUE;
}}

int password_is_correct(char* user_input){{
    return equalArrays(password, user_input, PASSWORDLENGTH-1);
}}

int main(int argc, char** argv){{
    puts(\"Welcome to the AEG challenges!\");
    char user_input[PASSWORDLENGTH];
    puts(\"Input password to continue:\");
    fflush(stdout);
    fgets(user_input, PASSWORDLENGTH, stdin);
    if (password_is_correct(user_input)){{
        printf(\"Correct password! :)\");
        fflush(stdout);
        system(\"/bin/sh\");
    }}else{{
        printf(\"Incorrect password. :(\");
    }}
    return 0;
}}"""
    f = open(filename, "w")
    f.write(file_content)
    f.close()

def generate_example_challenge_source_code(filename_stem, password):
    file_content = f"""#include <stdio.h>
#include <stdlib.h>

#define PASSWORDLENGTH 33
#define TRUE 1
#define FALSE 0
#define FILENAME \"{filename_stem}.txt\"

char* password = \"{password}\";

char equalArrays(char a[], char b[], int size){{
    for(int i = 0; i < size; i++){{
        if(a[i]!=b[i]){{
            return FALSE;
        }}
    }}
    return TRUE;
}}

void printBinary(){{
    char c;
    FILE * f;
    f = fopen(FILENAME, \"r\");
    if(f == NULL){{
        puts(\"Error reading hex of binary\");
        exit(0);
    }}
    c = fgetc(f);
    while (c != EOF){{
        printf(\"%c\", c);
        c = fgetc(f);
    }}
    fclose(f);
    return;
}}
int password_is_correct(char* user_input){{
    return equalArrays(password, user_input, PASSWORDLENGTH-1);
}}

int main(int argc, char** argv){{
    puts(\"Welcome to the AEG challenges!\");
    char user_input[PASSWORDLENGTH];
    puts(\"Input password to continue:\");
    fflush(stdout);
    fgets(user_input, PASSWORDLENGTH, stdin);
    if (password_is_correct(user_input)){{
        puts(\"Correct password! :)\");
        puts(\"Here is the binary that is currently running on this box: \");
        puts(\"-------------------------------------------------------------------\");
        printBinary();
        puts(\"-------------------------------------------------------------------\");
        fflush(stdout);
        system(\"/bin/sh\");
    }}else{{
        printf(\"Incorrect password. :(\");
    }}
    return 0;
}}"""

    f = open(filename_stem+".c", "w")
    f.write(file_content)
    f.close()

def generate_intermediate_Dockerfile(filename, round_number, port_base):
    print("In generate_intermediate_Dockerfile: port_base = " + str(port_base) + " and round_number = " + str(round_number))
    port = port_base+round_number
    file_content=f"""FROM debian:stretch

RUN apt-get update && apt-get upgrade -y && apt-get install -y socat && rm -rf /var/lib/apt/lists/*

RUN useradd -M chal

WORKDIR /opt/chal

COPY binary_{round_number} .
COPY message.txt .
COPY binary_{round_number}.txt .

RUN chmod 444 message.txt && chmod 555 binary_{round_number} && chmod 444 binary_{round_number}.txt

EXPOSE 5000
CMD ["socat", "-T60", "TCP-LISTEN:5000,reuseaddr,fork", "EXEC:./binary_{round_number}"]
"""
    f = open(filename, "w")
    f.write(file_content)
    f.close()

def generate_final_Dockerfile(filename, round_number, port_base):
    port = port_base + round_number
    file_content=f"""FROM debian:stretch

RUN apt-get update && apt-get upgrade -y && apt-get install -y socat && rm -rf /var/lib/apt/lists/*

RUN useradd -M chal

WORKDIR /opt/chal

COPY binary_{round_number} .
COPY binary_{round_number}.txt .
COPY flag.txt .

RUN chmod 444 flag.txt && chmod 444 binary_{round_number}.txt && chmod 555 binary_{round_number}

EXPOSE 5000
CMD ["socat", "-T60", "TCP-LISTEN:5000,reuseaddr,fork", "EXEC:./binary_{round_number}"]
"""
    f = open(filename, "w")
    f.write(file_content)
    f.close()