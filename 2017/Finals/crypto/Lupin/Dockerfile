FROM ubuntu:14.04

RUN apt-get update && \
    apt-get install -y gcc \
                    socat \
                    python \
					python-pip \
					python-dev

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN pip2 install reedsolo numpy

RUN mkdir /opt/chal
WORKDIR /opt/chal
COPY ./lpn_run.py /opt/chal/lpn_run.py 
RUN chmod +x ./lpn_run.py
CMD socat -T60 TCP-LISTEN:8000,reuseaddr,fork EXEC:/opt/chal/lpn_run.py,stderr

