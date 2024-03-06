# sudo docker build . –t bq
# sudo docker run -p 5000:5000 -it bq
# nc localhost 5000

FROM python:3

RUN apt update && apt install -y vim python3-pip socat 

RUN pip3 install sympy numpy

#RUN useradd -ms /bin/bash chal

RUN rm -rf /var/lib/apt/lists/*

WORKDIR /opt/chal

COPY server.py .
COPY flag.txt .
COPY password.txt .
COPY cipher ./cipher

#RUN chown -R chal:chal /opt/chal 
#RUN chown root:root flag.txt password.txt
RUN chmod 444 flag.txt password.txt server.py && chmod -w .

USER nobody
CMD ["socat", "-T60", "TCP-LISTEN:5000,reuseaddr,fork","EXEC:python3 ./server.py"]
