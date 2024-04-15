#!/usr/bin/env sh
docker build -t polluted_portfolio . \
&& docker run -it -p 8080:8080 --rm polluted_portfolio
