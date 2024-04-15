FROM rust:slim-buster as builder
WORKDIR /app
COPY Cargo.toml Cargo.lock /app/
COPY src/lib.rs src/main.rs /app/src/
RUN apt-get -y update && apt-get -y install build-essential m4 && cargo build --release

FROM debian:buster-slim

RUN apt-get -y update && apt-get -y install socat
WORKDIR /app
COPY --from=builder /app/target/release/hardcore /app/
USER nobody

CMD ["socat", "-T60", "TCP-LISTEN:5000,reuseaddr,pktinfo,fork,ignoreeof", "EXEC:/app/hardcore"]
