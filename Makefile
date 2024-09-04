all: up

up:
	mkdir -p /home/nkhoudro/Desktop/data/wp
	mkdir -p /home/nkhoudro/Desktop/data/db
	docker-compose -f ./src/docker-compose.yml up --build 

down:
	docker-compose -f ./src/docker-compose.yml down 

stop:
	docker-compose -f ./src/docker-compose.yml stop

start:
	docker-compose -f ./src/docker-compose.yml start

status:
	docker ps -a

fclean:
	docker-compose -f $(DOCKER_COMPOSE) down --volumes
	docker container prune -f
	docker volume prune -f
	docker image prune -f
	docker system prune -f
	sudo rm -rf /home/saboulal/data/*/* 
	docker network prune -f
	
