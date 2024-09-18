# use ubuntu 20 docker image as base
FROM ubuntu:20.04 as ctf

# update the package library and install the packages we need
# python3
# python3-pip
# socat - used to create multiple connections to the challenge box

# RUN executes the parameters in the context of the container
RUN apt-get update && apt-get install -y python3 python3-pip socat
RUN /usr/bin/python3 -m pip install numpy
# create a user called ctf so we're not running things as root
# otherwise, if they escape the challenge env, it'll be bad
RUN useradd -m ctf

# sets the working directory as /home/ctf
# this is the location where you get dropped when connecting to container
WORKDIR /home/ctf

# copy github repo /chal to the working directory
COPY ./chal .


# RUN cp -R /lib* /home/ctf && \
#     mkdir /home/ctf/usr && \
#     cp -R /usr/lib* /home/ctf/usr

# copy the start script
COPY ./start.sh /start.sh

# change the permissions of the working directory only to the ones needed
RUN chown -R root:ctf /home/ctf && \
    chmod -R 750 /home/ctf 

# give +x execution to the scripts
RUN chmod +x /start.sh
RUN chmod +x /home/ctf/run.sh
RUN chmod +x /home/ctf/chal.py

# socat listens on port 3000
# reuseaddr - makes the ip the same for all the connections
# fork - allows for multiple connections
# EXEC:/usr/bin/python3 - uses the python binary from the ubuntu image to run /home/ctf/chal.py
CMD ["socat", "-T300", "TCP-LISTEN:3000,reuseaddr,fork", "EXEC:/usr/bin/python3 /home/ctf/chal.py,pty,echo=0"]

# expose port 3000 as our challenge port
EXPOSE 3000