cd challenge
docker build -t challenge:latest .
docker run -d -p 8050:8050 challenge:latest