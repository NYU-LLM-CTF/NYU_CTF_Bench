sudo docker build -t hole . && sudo docker run -id -p "0.0.0.0:9999:9999" -h "hole" --name="hole" hole
