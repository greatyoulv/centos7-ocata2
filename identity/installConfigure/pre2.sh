#!/bin/sh
mysql -uroot -ppass -e"GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' \
IDENTIFIED BY 'pass';"
mysql -uroot -ppass -e"GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' \
IDENTIFIED BY 'pass';"
