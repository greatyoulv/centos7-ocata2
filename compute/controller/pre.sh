#!/bin/sh
mysql -uroot -ppass -e"CREATE DATABASE nova_api;"
mysql -uroot -ppass -e"CREATE DATABASE nova;"
mysql -uroot -ppass -e"CREATE DATABASE nova_cell0;"

mysql -uroot -ppass -e"GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' \
IDENTIFIED BY 'pass';"
mysql -uroot -ppass -e"GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' \
IDENTIFIED BY 'pass';"

mysql -uroot -ppass -e"GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' \
IDENTIFIED BY 'pass';"
mysql -uroot -ppass -e"GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' \
IDENTIFIED BY 'pass';"

mysql -uroot -ppass -e"GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' \
IDENTIFIED BY 'pass';"
mysql -uroot -ppass -e"GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' \
IDENTIFIED BY 'pass';"

source /root/admin-openrc

openstack user create --domain default --password pass nova
openstack role add --project service --user nova admin
openstack service create --name nova \
  --description "OpenStack Compute" compute
openstack endpoint create --region RegionOne \
  compute public http://controller:8774/v2.1
openstack endpoint create --region RegionOne \
  compute internal http://controller:8774/v2.1
openstack endpoint create --region RegionOne \
  compute admin http://controller:8774/v2.1

openstack user create --domain default --password pass placement
openstack role add --project service --user placement admin
openstack service create --name placement \
  --description "Placement API" placement
openstack endpoint create --region RegionOne \
  placement public http://controller:8778
openstack endpoint create --region RegionOne \
  placement internal http://controller:8778
openstack endpoint create --region RegionOne \
  placement admin http://controller:8778
