#!/usr/bin/env bash
MAP=$1

#run migrations
echo "Running migrations for $MAP";
cd /home/vagrant/projects/$MAP;
php artisan migrate;

#run migrations
echo "Running seeds for $MAP";
cd /home/vagrant/projects/$MAP;
php artisan db:seed;


