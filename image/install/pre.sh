#!/bin/sh
mysql -uroot -ppass -e"CREATE DATABASE glance;"
mysql -uroot -ppass -e"GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'pass';"
mysql -uroot -ppass -e"GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'pass';"
