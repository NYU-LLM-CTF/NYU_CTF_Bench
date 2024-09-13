cd challenge
docker build -t challenge:latest .
docker run -d -p 5000:5000 challenge:latest