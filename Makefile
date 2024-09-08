all: up

up:
	mkdir -p /home/nkh/Desktop/data/wp
	mkdir -p /home/nkh/Desktop/data/db
	docker-compose -f ./src/docker-compose.yml up -d --build 

down:
	docker-compose -f ./src/docker-compose.yml down 

stop:
	docker-compose -f ./src/docker-compose.yml stop

start:
	docker-compose -f ./src/docker-compose.yml start

status:
	docker ps -a

fclean:
	# docker-compose -f $(DOCKER_COMPOSE) down --volumes
	# docker stop $(docker ps -a -q)
	# docker rm $(docker ps -a -q)
	docker container prune -f
	docker volume prune -f
	docker image prune -f
	docker system prune -f
	sudo rm -rf /home/nkh/Desktop/data/*/* 
	sudo rm -rf /home/nkhoudro/Desktop/data/*/* 
	docker network prune -f
	
# docker stop $(docker ps -a -q)
# docker rm $(docker ps -a -q)