all: up

up:
	docker-compose -f ./src/docker-compose.yml up --build 

down :
	docker-compose -f ./src/docker-compose.yml down 

stop :
	docker-compose -f ./src/docker-compose.yml stop

start :
	docker-compose -f ./src/docker-compose.yml start

status :
	docker ps -a
