#!/usr/bin/env bash
MAP=$1
DB=$2;

#clean up first
echo "Dropping $DB database if it already exists.";
mysql -uhomestead -psecret -e "DROP DATABASE IF EXISTS $DB";

echo "Creating new database $DB";
mysql -uhomestead -psecret -e "CREATE DATABASE $DB";

#change database configuration
echo "Running configurations for $MAP";
#note that this is specifically changing the value on line 26
sed -i "26s/homestead/$DB/" /home/vagrant/projects/$MAP/app/config/local/database.php