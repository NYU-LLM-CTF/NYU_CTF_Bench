FROM debian:stretch
          
        RUN apt-get update && apt-get upgrade -y && dpkg --add-architecture i386 && apt-get update && apt-get install -y libc6-i386 socat file && rm -rf /var/lib/apt/lists/*

        RUN useradd -M chal

        WORKDIR /opt/chal

        COPY binary_40 .
        COPY binary_40.txt .
        COPY flag.txt .

        RUN chown -R chal:chal /opt/chal &&             chmod 444 /opt/chal/flag.txt &&             chmod 555 /opt/chal/binary_40 && \ 
            chmod 444 /opt/chal/binary_40.txt

        EXPOSE 5000
        USER chal
        CMD ["socat", "-T60", "TCP-LISTEN:5000,reuseaddr,fork", "EXEC:./binary_40"]
        