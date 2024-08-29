#!/bin/sh

cd ./service
uvicorn main:app --host 0.0.0.0 --port 8000 &

cd ../app
go run app.go