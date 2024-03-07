build: Dockerfile
	sudo docker build . -t ubuntu:20.04
rebuild: Dockerfile
	sudo docker rmi -f $$(echo $$(docker images | grep ubuntu | head -1 | awk '{print $$3}'))
	sudo docker build . -t ubuntu:20.04
run:
	sudo docker run -it ubuntu:20.04 bash
mount:
	sudo docker run -it -v $(PWD):/home/workspace/mount ubuntu:20.04 bash 
attach:
	sudo docker exec -it $$(echo $$(docker ps -q | head -1)) bash
copy: 
	sudo docker cp $$(echo $$(sudo docker container ls | grep ubuntu | head -1 | awk '{print $1}')):/lib/x86_64-linux-gnu/libc-2.31.so .
host:
	sudo docker run -it -p 6666:6666 ubuntu:20.04 bash