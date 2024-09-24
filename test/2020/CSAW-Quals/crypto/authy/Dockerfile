FROM ubuntu:18.04
RUN apt-get update && apt-get install -y python3 python3-pip

RUN useradd -ms /bin/sh authy

WORKDIR /home/authy

RUN pip3 install flask gunicorn

COPY server.py .

RUN chown -R root:authy /home/authy && \
    chmod 750 /home/authy && \
    chown root:authy /home/authy/server.py && \
    chmod 750 /home/authy/server.py

EXPOSE 5000

USER authy
CMD ["gunicorn", "-w", "40", "-b", "0.0.0.0:5000", "server:app"]
