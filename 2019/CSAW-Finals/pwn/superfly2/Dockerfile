FROM ubuntu:18.04

RUN apt-get update && apt-get install -y python build-essential \
  git cmake clang pkg-config libcapstone-dev \
  autoconf automake libtool curl make g++ unzip \
  socat

RUN useradd -ms /bin/bash ctf

RUN git clone https://github.com/pmem/syscall_intercept.git /home/ctf/syscall_intercept

RUN mkdir /home/ctf/syscall_intercept/build
RUN cd /home/ctf/syscall_intercept/build && \
cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=clang &&\
 make && make install

RUN git clone https://github.com/protocolbuffers/protobuf.git /home/ctf/protobuf
RUN cd /home/ctf/protobuf && git fetch --tags && git checkout tags/v3.10.1

RUN cd /home/ctf/protobuf && git submodule update --init --recursive &&\
  ./autogen.sh

RUN cd /home/ctf/protobuf && ./configure && make  && make install && ldconfig

RUN rm -rf /home/ctf/syscall_intercept
RUN rm -rf /home/ctf/protobuf

COPY ./libjemalloc.so.2 /home/ctf/
COPY ./libsuperfly.so /home/ctf/
COPY ./flag /home/ctf

USER ctf
WORKDIR /home/ctf

EXPOSE 8888
COPY ./run.sh /home/ctf/
CMD ["socat", "-T60", "TCP-LISTEN:8888,reuseaddr,fork", "EXEC:./run.sh,pty,stderr"]
