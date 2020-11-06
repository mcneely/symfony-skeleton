PHP_CLI_RUN_CMD = docker-compose run --no-deps php-cli

install-hook:
	cp app/scripts/pre-commit .git/hooks/pre-commit
	chmod 0777 .git/hooks/pre-commit
.PHONY:install-hook

copy:
	cp docker-compose.override.dist.yml docker-compose.override.yml
	cp .env.dist .env
.PHONY: copy

init: copy build
.PHONY: init

## DEVELOPMENT ##
build:
	docker-compose build
.PHONY: build

start:
	docker-compose up -d
.PHONY: start

stop:
	docker-compose down
.PHONY: stop

composer-install:
	$(PHP_CLI_RUN_CMD) composer install
.PHONY: composer-install

yarn-install:
	$(PHP_CLI_RUN_CMD) yarn install
	$(PHP_CLI_RUN_CMD) yarn build
.PHONY: yarn-install

deploy: composer-install
.PHONY: deploy

fix:
	$(PHP_CLI_RUN_CMD) php-cs-fixer fix src/
.PHONY: fix


## TESTS ##
phpunit:
	$(PHP_CLI_RUN_CMD) vendor/bin/phpunit --coverage-clover=build/coverage/coverage.xml --coverage-xml=build/coverage/ --coverage-html=build/coverage --whitelist src/ --bootstrap vendor/autoload.php tests/
.PHONY: phpunit

static:
	$(PHP_CLI_RUN_CMD) vendor/bin/phpstan -l max src tests
.PHONY: static

test: static phpunit
.PHONY: test

watch:
	$(PHP_CLI_RUN_CMD) yarn watch
.PHONY: watch

pull:
	git pull
.PHONY: pull

## PRODUCTION ##
prod-composer-install:
	$(PHP_CLI_RUN_CMD) composer install --no-dev
.PHONY:prod-composer-install

prod-yarn-install: yarn-install
	$(PHP_CLI_RUN_CMD) yarn install --production
.PHONY: prod-yarn-install

prod-deploy: pull prod-composer-install prod-yarn-install
.PHONY: deploy

prod-build: pull
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml build
.PHONY: prod-build

prod-start:
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
.PHONY: prod-start

prod-stop:
	prod-down": "docker-compose -f docker-compose.yml -f docker-compose.prod.yml down
.PHONY: prod-stop