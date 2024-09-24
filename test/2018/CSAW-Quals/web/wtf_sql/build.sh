#!/bin/sh

make app.sql
docker build -t=wtf_sql .
