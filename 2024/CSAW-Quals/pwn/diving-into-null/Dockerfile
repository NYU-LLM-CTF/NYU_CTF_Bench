FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends socat procps psmisc \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /home/bin
RUN cp /usr/bin/bash /home/bin/bash
RUN cp /usr/bin/socat /home/bin/socat

RUN mkdir -p /home/groot
RUN cp /root/.bashrc /home/groot/.bashrc
RUN cp /root/.profile /home/groot/.profile

RUN echo "No you're not groot" > /home/groot/.bash_history

RUN chmod 555 /home/groot && \
    groupadd groot && \
    useradd -g groot -d /home/groot -s /home/bin/bash groot && \
    chown groot:groot /home/groot

COPY flag.txt /home/groot/.flag

RUN chmod 600 /home/groot/.flag && \
    chown groot:groot /home/groot/.flag

RUN chmod 755 /home/bin/bash
RUN chmod 777 /home/bin/socat

RUN rm -rf /usr/bin

USER groot

EXPOSE 9191

CMD ["/home/bin/socat", "TCP-LISTEN:9191,reuseaddr,fork", "EXEC:/home/bin/bash,pty,stderr"]
