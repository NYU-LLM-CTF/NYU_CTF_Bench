
# generate_fmt_string_source_code.py
from random import choice, seed

def generate_level_one_source_code(filename_stem, password, random_seed):
    seed(random_seed)
    file_content_part_one = f"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>

#define PASSWORDLENGTH 32
#define TRUE 1
#define FALSE 0
#define BINARYNAME \"{filename_stem}.txt\"

#define CONTENTLENGTH 150

char* password = \"{password}\";\n\n"""

    function_list=f"""""";
    win_location = choice(range(100))
    for i in range(10):
        print("WIN LOCATION = " + str(win_location))
        print("RANDOM_SEED = " + str(random_seed))
        print("RANDOM_SEED_CLASS = " + str(random_seed.__class__()))
    for i in range(100):
        if i == win_location:
            function_list += f"""void win(){{
    system("/bin/sh");
    exit(0);
}}\n"""
        else:
            function_list += f"""void function{i}(){{
    exit(0);
}}\n"""
    print("function_list = " + function_list)
    file_content_last_part = f"""
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
    f = fopen(BINARYNAME, "r");
    if(f == NULL){{
        puts("Error reading hex of binary");
        exit(0);
    }}
    c = fgetc(f);
    while (c != EOF){{
        printf("%c", c);
        c = fgetc(f);
    }}
    fclose(f);
    return;
}}

int password_is_correct(char* user_input){{
    return equalArrays(password, user_input, PASSWORDLENGTH-1);
}}

void runChallenge(){{
    char userinput[CONTENTLENGTH];
    printf(\"*** Procrastination Simulator Level One ***\\n\\n\");
    printf(\"   Help! I need to write 60 reports by Sunday afternoon. Give me some content and I will generate a report!!\");
    puts(\"\");
    printf(\"> \");
    fflush(stdout);
    fgets(userinput, CONTENTLENGTH, stdin);
    puts(\"Thanks! I\'ll work with the following:\\n\");
    printf(userinput);
    puts(\"Time to go write this!\");
    exit(0);
}}

int main(int argc, char **argv){{
    puts(\"Welcome to the AEG challenges!\");
    char user_input[PASSWORDLENGTH];
    puts(\"Input password to continue:\");
    printf(\"> \");
    fflush(stdout);
    fgets(user_input, PASSWORDLENGTH+2, stdin);
    if (password_is_correct(user_input)){{
        puts(\"Correct password! :)\");
        puts(\"Here is the binary that is currently running on this box: \");
        puts(\"-------------------------------------------------------------------\");
        printBinary();
        puts(\"-------------------------------------------------------------------\");
        puts(\"\\nProceeding to the challenge...\\n\");
        fflush(stdout);
        runChallenge();
    }}else{{
        printf(\"Incorrect password. :(\");
    }}
    return 0;
}}"""
    f = open(filename_stem+".c", "w")
    f.write(file_content_part_one)
    f.write(function_list)
    f.write(file_content_last_part)
    f.close()
    return


def generate_level_two_source_code(filename_stem, password, random_seed):
    seed(random_seed)
    file_content_part_one = f"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>

#define PASSWORDLENGTH 32
#define TRUE 1
#define FALSE 0
#define BINARYNAME \"{filename_stem}.txt\"

#define CONTENTLENGTH 200

char* password = \"{password}\";\n\n"""

    function_list=f"""""";
    win_location = choice(range(100))
    for i in range(100):
        if i == win_location:
            function_list += f"""void win(){{
    system("/bin/sh");
    exit(0);
}}\n"""
        else:
            function_list += f"""void function{i}(){{
    exit(0);
}}\n"""
    print("function_list = " + function_list)
    file_content_last_part = f"""
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
    f = fopen(BINARYNAME, "r");
    if(f == NULL){{
        puts("Error reading hex of binary");
        exit(0);
    }}
    c = fgetc(f);
    while (c != EOF){{
        printf("%c", c);
        c = fgetc(f);
    }}
    fclose(f);
    return;
}}

int password_is_correct(char* user_input){{
    return equalArrays(password, user_input, PASSWORDLENGTH-1);
}}

void runChallenge(){{
    char userinput[CONTENTLENGTH];
    printf(\"*** Procrastination Simulator Level Two ***\\n\\n\");
    printf(\"   Help! I need to write 60 reports by Sunday afternoon. Give me some content and I will generate a report!!\");
    puts(\"\");
    printf(\"> \");
    fflush(stdout);
    fgets(userinput, CONTENTLENGTH, stdin);
    puts(\"Thanks! I\'ll work with the following:\\n\");
    printf(userinput);
    puts(\"Time to go write this!\");
    exit(0);
}}

int main(int argc, char **argv){{
    puts(\"Welcome to the AEG challenges!\");
    char user_input[PASSWORDLENGTH];
    puts(\"Input password to continue:\");
    printf(\"> \");
    fflush(stdout);
    fgets(user_input, PASSWORDLENGTH+2, stdin);
    if (password_is_correct(user_input)){{
        puts(\"Correct password! :)\");
        puts(\"Here is the binary that is currently running on this box: \");
        puts(\"-------------------------------------------------------------------\");
        printBinary();
        puts(\"-------------------------------------------------------------------\");
        puts(\"\\nProceeding to the challenge...\\n\");
        fflush(stdout);
        runChallenge();
    }}else{{
        printf(\"Incorrect password. :(\");
    }}
    return 0;
}}"""
    f = open(filename_stem+".c", "w")
    f.write(file_content_part_one)
    f.write(function_list)
    f.write(file_content_last_part)
    f.close()
    return

def generate_level_three_source_code(filename_stem, password, random_seed):
    seed(random_seed)
    file_content_part_one = f"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>

#define PASSWORDLENGTH 32
#define TRUE 1
#define FALSE 0
#define BINARYNAME \"{filename_stem}.txt\"

#define CONTENTLENGTH 200

char* password = \"{password}\";\n\n"""

    function_list=f"""""";
    win_location = choice(range(100))
    for i in range(100):
        if i == win_location:
            function_list += f"""void win(){{
    system("/bin/sh");
    exit(0);
}}\n"""
        else:
            function_list += f"""void function{i}(){{
    exit(0);
}}\n"""
    print("function_list = " + function_list)
    file_content_last_part = f"""
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
    f = fopen(BINARYNAME, "r");
    if(f == NULL){{
        puts("Error reading hex of binary");
        exit(0);
    }}
    c = fgetc(f);
    while (c != EOF){{
        printf("%c", c);
        c = fgetc(f);
    }}
    fclose(f);
    return;
}}

int password_is_correct(char* user_input){{
    return equalArrays(password, user_input, PASSWORDLENGTH-1);
}}

void runChallenge(){{
    char userinput[CONTENTLENGTH];
    printf(\"*** Procrastination Simulator Level Three ***\\n\\n\");
    printf(\"   Help! I need to write 60 reports by Sunday afternoon. Give me some content and I will generate a report!!\");
    puts(\"\");
    printf(\"> \");
    fflush(stdout);
    fgets(userinput, CONTENTLENGTH, stdin);
    puts(\"Thanks! I\'ll work with the following:\\n\");
    printf(userinput);
    puts(\"Time to go write this!\");
    exit(0);
}}

int main(int argc, char **argv){{
    puts(\"Welcome to the AEG challenges!\");
    char user_input[PASSWORDLENGTH];
    puts(\"Input password to continue:\");
    printf(\"> \");
    fflush(stdout);
    fgets(user_input, PASSWORDLENGTH+2, stdin);
    if (password_is_correct(user_input)){{
        puts(\"Correct password! :)\");
        puts(\"Here is the binary that is currently running on this box: \");
        puts(\"-------------------------------------------------------------------\");
        printBinary();
        puts(\"-------------------------------------------------------------------\");
        puts(\"\\nProceeding to the challenge...\\n\");
        fflush(stdout);
        runChallenge();
    }}else{{
        printf(\"Incorrect password. :(\");
    }}
    return 0;
}}"""
    f = open(filename_stem+".c", "w")
    f.write(file_content_part_one)
    f.write(function_list)
    f.write(file_content_last_part)
    f.close()
    return

def generate_example_challenge_source_code(filename_stem, password, random_seed):
    seed(random_seed)
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

def generate_level_four_source_code(filename_stem, password, random_seed):
    seed(random_seed)
    file_content = f"""#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>

#define PASSWORDLENGTH 32
#define TRUE 1
#define FALSE 0
#define BINARYNAME \"{filename_stem}.txt\"

#define CONTENTLENGTH 200

char* password = \"{password}\";

int report_number;

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
    f = fopen(BINARYNAME, \"r\");
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

int password_is_correct(char* user_input, char* password){{
    return equalArrays(password, user_input, PASSWORDLENGTH-1);
}}

void runChallenge(){{
    char userinput[CONTENTLENGTH];
    int * report_number_location = &report_number;

    printf(\"*** Procrastination Simulator Level Four ***\\n\\n\");
    while (report_number < 3){{
        printf(\"   Help! I need to write 60 reports by Sunday afternoon and I\'m doing three reports at once. Give me some content and I will generate Report %d in this batch!!\", *report_number_location+1);
        puts(\"\");
        printf(\"> \");
        fflush(stdout);
        fgets(userinput, CONTENTLENGTH, stdin);
        printf(\"Thanks! Here are the contents of Report %d:\\n\", *report_number_location+1);
        printf(userinput);
        puts(\"Time to go write this!\");
        report_number += 1;
        memset(userinput, 0, CONTENTLENGTH);
    }}
    exit(0);
}}

int main(int argc, char **argv){{
    puts(\"Welcome to the AEG challenges!\");
    char user_input[PASSWORDLENGTH];
    puts(\"Input password to continue:\");
    printf(\"> \");
    fflush(stdout);
    fgets(user_input, PASSWORDLENGTH+2, stdin);
    if (password_is_correct(user_input, password)){{
        puts(\"Correct password! :)\");
        puts(\"Here is the binary that is currently running on this box: \");
        puts(\"-------------------------------------------------------------------\");
        printBinary();
        puts(\"-------------------------------------------------------------------\");
        puts(\"\\nProceeding to the challenge...\\n\");
        fflush(stdout);
        runChallenge();
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

RUN sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list
RUN sed -i '/stretch-updates/d' /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y && dpkg --add-architecture i386 && apt-get update && apt-get install -y libc6-i386 socat file && rm -rf /var/lib/apt/lists/*

RUN useradd -M chal

WORKDIR /opt/chal

COPY binary_{round_number} .
COPY message.txt .
COPY binary_{round_number}.txt .

RUN chown -R root:chal /opt/chal && \
  chmod 444 /opt/chal/message.txt && \
  chmod 555 /opt/chal/binary_{round_number} && \
  chmod 444 /opt/chal/binary_{round_number}.txt

EXPOSE 5000
USER chal
CMD ["socat", "-T60", "TCP-LISTEN:5000,reuseaddr,fork", "EXEC:./binary_{round_number}"]
"""
    f = open(filename, "w")
    f.write(file_content)
    f.close()

def generate_intermediate_level_four_Dockerfile(filename, round_number, port_base):
    print("In generate_intermediate_Dockerfile: port_base = " + str(port_base) + " and round_number = " + str(round_number))
    port = port_base+round_number
    file_content=f"""FROM ubuntu:20.04

RUN sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list
RUN sed -i '/stretch-updates/d' /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y && dpkg --add-architecture i386 && apt-get update && apt-get install -y libc6-i386 socat file && rm -rf /var/lib/apt/lists/*

RUN useradd -M chal

WORKDIR /opt/chal

COPY binary_{round_number} .
COPY message.txt .
COPY binary_{round_number}.txt .

RUN chown -R root:chal /opt/chal && \
  chmod 444 /opt/chal/message.txt && \
  chmod 555 /opt/chal/binary_{round_number} && \
  chmod 444 /opt/chal/binary_{round_number}.txt

EXPOSE 5000
USER chal
CMD ["socat", "-T60", "TCP-LISTEN:5000,reuseaddr,fork", "EXEC:./binary_{round_number}"]
"""
    f = open(filename, "w")
    f.write(file_content)
    f.close()



def generate_final_Dockerfile(filename, round_number, port_base):
    port = port_base + round_number
    file_content=f"""FROM debian:stretch

RUN sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list
RUN sed -i '/stretch-updates/d' /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y && dpkg --add-architecture i386 && apt-get update && apt-get install -y libc6-i386 socat file && rm -rf /var/lib/apt/lists/*

RUN useradd -M chal

WORKDIR /opt/chal

COPY binary_{round_number} .
COPY binary_{round_number}.txt .
COPY flag.txt .

RUN chown -R root:chal /opt/chal && \
  chmod 444 /opt/chal/flag.txt && \
  chmod 555 /opt/chal/binary_{round_number} && \
  chmod 444 /opt/chal/binary_{round_number}.txt

EXPOSE 5000
USER chal
CMD ["socat", "-T60", "TCP-LISTEN:5000,reuseaddr,fork", "EXEC:./binary_{round_number}"]
"""
    f = open(filename, "w")
    f.write(file_content)
    f.close()

def generate_final_level_four_Dockerfile(filename, round_number, port_base):
    port = port_base + round_number
    file_content=f"""FROM ubuntu:20.04

RUN sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list
RUN sed -i '/stretch-updates/d' /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y && dpkg --add-architecture i386 && apt-get update && apt-get install -y libc6-i386 socat file && rm -rf /var/lib/apt/lists/*

RUN useradd -M chal

WORKDIR /opt/chal

COPY binary_{round_number} .
COPY binary_{round_number}.txt .
COPY flag.txt .

RUN chown -R root:chal /opt/chal && \
  chmod 444 /opt/chal/flag.txt && \
  chmod 555 /opt/chal/binary_{round_number} && \
  chmod 444 /opt/chal/binary_{round_number}.txt

EXPOSE 5000
USER chal
CMD ["socat", "-T60", "TCP-LISTEN:5000,reuseaddr,fork", "EXEC:./binary_{round_number}"]
"""
    f = open(filename, "w")
    f.write(file_content)
    f.close()
