#!/usr/bin/env bash
MAP=$1
DB=$2

#run migrations
echo "Running configurations for $MAP";
#note that this is specifically changing the value on line 26
sed -i "26s/homestead/$DB/" /home/vagrant/projects/$MAP/app/config/local/database.php