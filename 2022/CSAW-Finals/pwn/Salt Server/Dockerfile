FROM ubuntu:22.04

RUN apt-get update && \
    apt-get upgrade -y && \
        apt-get install -y libssl3

RUN useradd -ms /bin/bash csaw

ADD src/saltserver /home/csaw/salt_server
ADD src/flag.txt /home/csaw/flag.txt

RUN chmod 555 /home/csaw/salt_server
RUN chown root:csaw /home/csaw/flag.txt
RUN chmod 444 /home/csaw/flag.txt

USER csaw
WORKDIR /home/csaw/

ENTRYPOINT ["/home/csaw/salt_server"]
