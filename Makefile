install: hooks
	cd ./docker && ./install.sh

start: hooks
	cd ./docker && ./start.sh

stop:
	cd ./docker && ./stop.sh

restart: stop start

hooks:
	echo "#!/bin/bash" > .git/hooks/pre-commit
	echo "make check" >> .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit

xdebug-enable:
	cd ./docker && docker-compose exec -T -u 0 php docker-php-ext-enable xdebug
	cd ./docker && docker-compose exec -T -u 0 php bash -c "kill -USR2 1"

xdebug-disable:
	cd ./docker && docker-compose exec -T -u 0 php sed -i '/zend_extension/d' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
	cd ./docker && docker-compose exec -T -u 0 php bash -c "kill -USR2 1"

shell:
	cd ./docker && docker-compose exec php bash

warmup-cache:
	bin/console cache:warmup
migrations:
	bin/console doctrine:database:create --if-not-exists
	bin/console doctrine:migration:migrate --allow-no-migration --no-interaction

check:
	cd ./docker/ && docker-compose exec -T php make phpcs
	cd ./docker/ && docker-compose exec -T php make stan
	cd ./docker/ && docker-compose exec -T php make doctrine
	cd ./docker/ && docker-compose exec -T php make phpunit

phpcs:
	vendor/bin/phpcs

fixer:
	./vendor/bin/phpcbf

stan:
	bin/console cache:warmup --env=test
	export APP_ENV=test && vendor/bin/phpstan analyse --memory-limit=4000M

doctrine:
	bin/console d:s:v --env=test
	bin/console d:s:u --dump-sql --env=test

phpunit:
	bin/phpunit
