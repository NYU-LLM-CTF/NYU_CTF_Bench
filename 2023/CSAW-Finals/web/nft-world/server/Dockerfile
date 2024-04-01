FROM golang:1.20

WORKDIR /usr/src/app

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .
RUN mkdir /csaw_chall
RUN go build -o /csaw_chall/app
RUN cp -r ./static /csaw_chall
RUN cp -r ./dist /csaw_chall
RUN cp flag.txt.gpg /csaw_chall

WORKDIR /csaw_chall
RUN chmod +x ./app

EXPOSE 3333

CMD ["./app"]