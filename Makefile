COMPOSE_FILE = srcs/docker-compose.yaml
DB_VOL = /home/yiken/data/db
WWW_VOL = /home/yiken/data/www
VOLUMES = $(shell docker volume ls -q)

all:
	@docker compose -f $(COMPOSE_FILE) up -d --pull never

clean:
	@docker compose -f $(COMPOSE_FILE) down

fclean:	#run with sudo
	-@docker compose -f $(COMPOSE_FILE) down --rmi all
	-@docker volume rm $(VOLUMES)
	-@rm -rf $(DB_VOL) && mkdir $(DB_VOL)
	-@rm -rf $(WWW_VOL) && mkdir $(WWW_VOL)
re:	fclean all #run with sudo

stop:
	@docker compose -f $(COMPOSE_FILE) stop
