COMPOSE_FILE = srcs/docker-compose.yml
DB_VOL = ~/data/db
WWW_VOL = ~/data/www
VOLUMES = $(shell docker volume ls -q)

all:
	@mkdir -p $(DB_VOL)
	@mkdir -p $(WWW_VOL)
	@docker compose -f $(COMPOSE_FILE) up -d --pull never

down:
	@docker compose -f $(COMPOSE_FILE) down

fclean:	#run with sudo
	-@docker compose -f $(COMPOSE_FILE) down --rmi all
	-@docker volume rm $(VOLUMES)
	-@rm -rf $(DB_VOL)
	-@rm -rf $(WWW_VOL)
re:	fclean all #run with sudo

stop:
	@docker compose -f $(COMPOSE_FILE) stop
