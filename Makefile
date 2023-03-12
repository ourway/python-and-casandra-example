.DEFAULT_GOAL := start

#include .env
#export

#override DOCKER_NETWORK := $(shell docker network list | awk '{print $$2}' | awk '/SOMETHING/')




start:
	@make clean
	@docker compose -f docker-compose.yml up --build --remove-orphans --wait -d

clean:
	@docker compose -f docker-compose.yml stop
	@docker compose -f docker-compose.yml rm -f
	@docker compose -f docker-compose.yml kill
	@docker volume prune -f
	@docker network prune -f
	@rm -f Dockerfile.local

test:
	@docker compose exec -it app python3 create_tables.py
	@docker compose exec -it app python3 seed_db.py
	@docker compose exec -it app python3 query.py
