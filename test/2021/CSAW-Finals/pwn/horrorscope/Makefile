build: Dockerfile
	docker build . -t ubuntu:latest
rebuild: Dockerfile
	docker rmi -f $$(echo $$(docker images | grep ubuntu | head -1 | awk '{print $$3}'))
	docker build . -t ubuntu:latest
run:
	docker run -it ubuntu:latest bash
mount:
	docker run -it -v $(PWD):/home/workspace/mount ubuntu:latest bash 

attach:
	docker exec -it $$(echo $$(docker ps -q | head -1)) bash