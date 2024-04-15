FROM rust:slim-buster

WORKDIR /app

COPY Cargo.toml Cargo.lock /app/
COPY src/lib.rs src/main.rs /app/src/
COPY static /app/static
COPY templates /app/templates

RUN apt-get -y update \
  && apt-get -y install build-essential m4 \
  && cargo build --release \
  && cp /app/target/release/iBad /app/ \
  && rm -rf target

USER nobody
CMD /app/iBad
