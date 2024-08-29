FROM alpine:3.14

RUN apk add --no-cache git go python3 py3-pip

WORKDIR /usr/src/chal
COPY . .


# setup python
WORKDIR /usr/src/chal/service
RUN pip install --upgrade pip
RUN pip install -r requirements.txt


# setup golang
WORKDIR /usr/src/chal/app
ENV GOROOT /usr/lib/go
ENV GOPATH /go
ENV PATH /go/path:$PATH

RUN mkdir -p ${GOPATH}/src ${GOPATH}/bin
RUN go mod vendor


# final things
WORKDIR /usr/src/chal
EXPOSE 1234
RUN chmod -R 775 /usr/src/chal

CMD ["./run.sh"]