#!/usr/bin/env bash
DB=$1;

#clean up first
echo "Dropping $DB database if it already exists.";
mysql -uhomestead -psecret -e "DROP DATABASE IF EXISTS $DB";

echo "Creating new database $DB";
mysql -uhomestead -psecret -e "CREATE DATABASE $DB";
