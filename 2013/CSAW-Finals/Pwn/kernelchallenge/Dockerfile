FROM ubuntu:16.04
MAINTAINER Oskar
LABEL Description="CSAW 2013-F: Kernel Challenge" VERSION='1.0'
# Update
RUN apt-get update && apt-get upgrade -y 
RUN apt-get install -y socat build-essential make
# User
RUN adduser --disabled-password --gecos '' kernelchal
RUN chown -R root:kernelchal /home/kernelchal/
RUN chmod 750 /home/kernelchal
RUN chmod 740 /usr/bin/top
RUN chmod 740 /bin/ps
RUN chmod 740 /usr/bin/pgrep
RUN export TERM=xterm
# Files
WORKDIR /home/kernelchal/
COPY main.c /home/kernelchal
COPY flag /home/kernelchal
COPY Makefile /home/kernelchal
RUN chown root:kernelchal /home/kernelchal/flag
RUN chmod 440 /home/kernelchal/flag
RUN make 
RUN strip -s kernelchal
RUN rm main.c
# Execute
EXPOSE 8025
CMD su kernelchal -c "socat -T10 TCP-LISTEN:8025,reuseaddr,fork EXEC:/home/kernelchal/kernelchal"