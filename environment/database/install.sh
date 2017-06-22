#!/bin/sh
yum install mariadb mariadb-server python2-PyMySQL -y
touch /etc/my.cnf.d/openstack.cnf
echo "[mysqld]
bind-address = 10.0.0.112

default-storage-engine = innodb
innodb_file_per_table = on
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8" > /etc/my.cnf.d/openstack.cnf

systemctl enable mariadb.service
systemctl start mariadb.service
