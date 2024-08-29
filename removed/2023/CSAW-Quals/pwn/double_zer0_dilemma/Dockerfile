FROM ubuntu:20.04 as ctf

# Set environment variables.
ENV HOME /root
RUN id
#install gcc
RUN apt-get update
RUN apt-get install -y gcc
RUN apt-get install -y g++-multilib
RUN apt-get install -y socat
RUN apt-get install -y gdb

#disable ASLR to be nice.
#RUN echo 0 > /proc/sys/kernel/randomize_va_space
RUN sysctl kernel.randomize_va_space=0

#Create a new user & for the challenge
RUN groupadd --gid 995 ctf
RUN useradd -m --uid 995 --gid 995 ctf

#copy the current dir into the users dir
COPY ./chal /home/ctf/

#change to the users directory
WORKDIR /home/ctf/
#DEBUG
#RUN ls -al

#compile the file without protections
#RUN gcc -fno-stack-protector -no-pie -Wl,--section-start=.text=0x808a000 src/roulette.c -o double_zer0_dilemma -ldl
RUN rm -r src
RUN chown -R root:root .
RUN chmod 755 double_zer0_dilemma
RUN chmod 755 flag

EXPOSE 9999:9999

USER ctf

CMD ["socat", "-T60", "TCP-LISTEN:9999,reuseaddr,fork", "EXEC:./double_zer0_dilemma"]
