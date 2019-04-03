#!/bin/bash
echo installing last steps...
cp ./.env.example ./.env
docker-compose build
docker-compose up -d
docker exec docker4laravel_app_1 php artisan key:generate
docker exec docker4laravel_app_1 php artisan config:cache
echo Installation completed
