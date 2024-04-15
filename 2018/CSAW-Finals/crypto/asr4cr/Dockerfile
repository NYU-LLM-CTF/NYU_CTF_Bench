FROM ubuntu:18.04

RUN apt-get update && apt-get upgrade -y
RUN apt-get install socat build-essential -y 

RUN useradd -ms /bin/sh asr4cr  

WORKDIR /home/asr4cr

#COPY ./asr4cr.c ./
#COPY ./Makefile ./
#RUN make ./

COPY ./asr4cr ./ 
RUN chown asr4cr ./asr4cr

EXPOSE 4141

USER asr4cr
CMD ["socat","-T10", "TCP-LISTEN:4141,reuseaddr,fork", "EXEC:/home/asr4cr/asr4cr"]


