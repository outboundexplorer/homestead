#!/usr/bin/env bash
MAP=$1

#run migrations
echo "Add developer tools";
cd /home/vagrant/projects/$MAP

echo "Installing Laravel-ide-helper"
composer require barryvdh/laravel-ide-helper --dev

echo "Installing Laravel-debugbar"
composer require barryvdh/laravel-debugbar --dev

echo "Installing PHPUnit"
composer require phpunit/phpunit --dev

echo "Installing elasticsearch-php client"
composer require elasticsearch/elasticsearch

echo "Installing Faker"
composer require fzaninotto/faker --dev