include .env

#-----------------------------------------------------------
# Docker
#-----------------------------------------------------------

# Wake up docker containers
up:
	docker-compose up -d

# Shut down docker containers
down:
	docker-compose down

# Show a status of each container
status:
	docker-compose ps

# Status alias
s: status

# Show logs of each container
logs:
	docker-compose logs

# Watch client output
logs-node:
	docker logs -f ${NODE_CONTAINER}

# Restart all containers
restart: down up

# Restart the node container
restart-node:
	docker-compose restart node

# Restart the node container alias
rn: restart-node

# Build and up docker containers
build:
	docker-compose up -d --build --scale webserver=3

# Build containers with no cache option
build-no-cache:
	docker-compose build --no-cache

# Build and up docker containers
rebuild: down build

deploy: rebuild composer-install-t migrate-force restart-client

# Run terminal of the php container
php:
	docker-compose exec php bash

# Run terminal of the node container
node:
	docker-compose exec node /bin/sh

# Run terminal of the mysql container
mysql:
	docker-compose exec db

# Run terminal of the redis container
redis:
	docker-compose exec redis

# Run terminal of the postgres container
postgres:
	docker-compose exec db

#-----------------------------------------------------------
# Database
#-----------------------------------------------------------

# Run database migrations
db-migrate:
	docker-compose exec php php artisan migrate

# Migrate alias
migrate: db-migrate

migrate-force:
	docker-compose exec -T php php artisan migrate --force

# Run migrations rollback
db-rollback:
	docker-compose exec php php artisan migrate:rollback

# Rollback alias
rollback: db-rollback

# Run seeders
db-seed:
	docker-compose exec php php artisan db:seed

# Fresh all migrations
db-fresh:
	docker-compose exec php php artisan migrate:fresh

#-----------------------------------------------------------
# Testing
#-----------------------------------------------------------

# Run phpunit tests
test:
	docker-compose exec php vendor/bin/phpunit --order-by=defects --stop-on-defect

# Run all tests ignoring failures.
test-all:
	docker-compose exec php vendor/bin/phpunit --order-by=defects

# Run phpunit tests with coverage
coverage:
	docker-compose exec php vendor/bin/phpunit --coverage-html tests/report

# Run phpunit tests
dusk:
	docker-compose exec php php artisan dusk

# Generate metrics
metrics:
	docker-compose exec php vendor/bin/phpmetrics --report-html=api/tests/metrics api/app

php-fix: phpcbf phpstan
phpcs:
	docker-compose exec php vendor/bin/phpcs -n

phpcbf:
	docker-compose exec php vendor/bin/phpcbf -n

phpstan:
	docker-compose exec php vendor/bin/phpstan analyse --memory-limit=1G --no-progress -n


#-----------------------------------------------------------
# Dependencies
#-----------------------------------------------------------

# Install composer dependencies
composer-install:
	docker-compose exec php composer install

composer-install-t:
	docker-compose exec -T php composer install

# Update composer dependencies
composer-update:
	docker-compose exec php composer update

# Update npm dependencies
npm-update:
	docker-compose exec node npm update

# Update all dependencies
dependencies-update: composer-update npm-update

# Show composer outdated dependencies
composer-outdated:
	docker-compose exec npm outdated

# Show npm outdated dependencies
npm-outdated:
	docker-compose exec npm outdated

# Show all outdated dependencies
outdated: npm-update composer-outdated


#-----------------------------------------------------------
# Tinker
#-----------------------------------------------------------

# Run tinker
tinker:
	docker-compose exec php php artisan tinker


#-----------------------------------------------------------
# Installation
#-----------------------------------------------------------

# Copy the Laravel API environment file
env-api:
	cp .env.api api/.env

# Copy the NuxtJS environment file
env-client:
	cp .env.client client/.env

# Add permissions for Laravel cache and storage folders
permissions:
	sudo chown -R $$USER:www-data storage
	sudo chown -R $$USER:www-data bootstrap/cache
	sudo chmod -R 775 bootstrap/cache
	sudo chmod -R 775 storage

# Permissions alias
perm: permissions

# Generate a Laravel + JWT key
key:
	docker-compose exec php php artisan key:generate --ansi
	# docker-compose exec php php artisan jwt:secret --ansi

# Generate a Laravel storage symlink
storage:
	docker-compose exec php php artisan storage:link

# PHP composer autoload command
autoload:
	docker-compose exec php composer dump-autoload

# Install the environment
install: build composer-install key storage permissions migrate rn
install-win: build composer-install key storage migrate rn

#-----------------------------------------------------------
# Clearing
#-----------------------------------------------------------

# Shut down and remove all volumes
remove-volumes:
	docker-compose down --volumes

# Remove all existing networks (useful if network already exists with the same attributes)
prune-networks:
	docker network prune
