#!/bin/bash
echo installing last steps...
cp ./.env.example ./.envchmod +x
docker-compose build
docker-compose up -d
docker exec docker4laravel_app_1 php artisan key:generate
docker exec docker4laravel_app_1 php artisan config:cache
docker exec docker4laravel_app_1 php artisan migrate