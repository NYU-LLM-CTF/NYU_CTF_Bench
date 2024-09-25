FROM ubuntu:14.04
MAINTAINER unknonwn
LABEL Description="CSAW 2016 Detective" VERSION='1.0'

#installation
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get upgrade -y 
RUN apt-get install -y build-essential socat libc6:i386 libncurses5:i386 libstdc++6:i386 libc6-dev-i386

#user
RUN adduser --disabled-password --gecos '' detective 
RUN chown -R root:detective /home/detective/
RUN chmod 750 /home/detective

RUN touch /home/detective/flag.txt
RUN touch /home/detective/criminal.txt
RUN touch /home/detective/answer.txt

RUN chmod 740 /usr/bin/top
RUN chmod 740 /bin/ps
RUN chmod 740 /usr/bin/pgrep
RUN export TERM=xterm

#Copying file
WORKDIR /home/detective/
COPY detective.c /home/detective
COPY answer.txt /home/detective
COPY criminal.txt /home/detective
COPY flag.txt /home/detective
COPY Makefile /home/detective

#Compiling  the program
RUN make
RUN strip --strip-all detective

#Setting perm.
RUN chown root:detective /home/detective/flag.txt
RUN chown root:detective /home/detective/criminal.txt
RUN chown root:detective /home/detective/answer.txt

RUN chmod 440 /home/detective/flag.txt
RUN chmod 440 /home/detective/criminal.txt
RUN chmod 440 /home/detective/answer.txt

#Remove files
RUN rm /home/detective/detective.c 
RUN rm /home/detective/Makefile

#Run the program with socat
CMD su detective -c "setarch `uname -m` -R socat TCP-LISTEN:4242,reuseaddr,fork EXEC:/home/detective/detective"
