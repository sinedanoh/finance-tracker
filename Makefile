.PHONY: help up down build ps exec migrate test cache-clear logs

COMPOSE_DEV = docker compose -f docker-compose.yaml -f docker/dev/docker-compose.override.yaml
COMPOSE_PROD = docker compose -f docker-compose.yaml -f docker/prod/docker-compose.prod.yaml
PHP_CONTAINER = php

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Development commands
up: ## Start development environment
	$(COMPOSE_DEV) up -d

down: ## Stop development environment
	$(COMPOSE_DEV) down

stop-all: ## Stop all containers
	@docker ps -a -q | xargs -r docker stop

build: ## Rebuild development containers
	$(COMPOSE_DEV) build --no-cache

ps: ## Show container status
	$(COMPOSE_DEV) ps

exec: ## Enter PHP container with fish shell
	$(COMPOSE_DEV) exec $(PHP_CONTAINER) fish

migrate: ## Run database migrations
	$(COMPOSE_DEV) exec $(PHP_CONTAINER) php bin/console doctrine:migrations:migrate --no-interaction

test: ## Run tests
	$(COMPOSE_DEV) exec $(PHP_CONTAINER) php bin/phpunit

cache-clear: ## Clear Symfony cache
	$(COMPOSE_DEV) exec $(PHP_CONTAINER) php bin/console cache:clear

logs: ## View container logs
	$(COMPOSE_DEV) logs -f

# Production commands
prod-up: ## Start production environment
	$(COMPOSE_PROD) --env-file .env.prod up -d

prod-down: ## Stop production environment
	$(COMPOSE_PROD) --env-file .env.prod down

prod-build: ## Rebuild production containers
	$(COMPOSE_PROD) --env-file .env.prod build --no-cache

prod-logs: ## View production logs
	$(COMPOSE_PROD) --env-file .env.prod logs -f
