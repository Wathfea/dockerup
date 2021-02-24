# PENTACOM DOCKER #

Dockerizált környezet a fejlesztéseink megkönnyítéséhez
Elérhető szolgáltatások

* PHP `make php`
* NGINX
* ADMINER (@TODO PHPMYADMIN) `http://{PROJECT_PATH}:8080`
* MYSQL `make mysql`
* POSTGRES `make postgres`
* REDIS `make redis`
* NODE `make node`
* LOAD BALANCER
* MAILHOG `http://{PROJECT_PATH}:8025`

### Kezdeti lépések ###

* `composer install` futtatása
* Szerkeszd a .env filet adj meg egy `PROJECT_PATH` értéket
* `laravel new ...` futtatása a `...` egyezzen meg a `PROJECT_PATH` értékével
* Másold át az `nginx/conf.d/laravel.conf.example` filet nevezd át `PROJECT_PATH.conf` névre és szerkeszd a szükséges részeket
* Add hozzá a vhost-ot a hosts fileodhoz
* `make build` futtatása a Docker indításhoz
* `make down` futtatása a Docker leállításához
* Következő alkalommal már `make up` futtatása elegendő
* Böngészőben http://{PROJECT_PATH}:8000 érhető el a site
