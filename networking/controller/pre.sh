#!/bin/sh
mysql -uroot -ppass -e"CREATE DATABASE neutron;"
mysql -uroot -ppass -e"GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' \
IDENTIFIED BY 'pass';"
mysql -uroot -ppass -e"GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' \
IDENTIFIED BY 'pass';"

source /root/admin-openrc
openstack user create --domain default --password pass neutron
openstack role add --project service --user neutron admin
openstack service create --name neutron \
  --description "OpenStack Networking" network
openstack endpoint create --region RegionOne \
  network public http://controller:9696
openstack endpoint create --region RegionOne \
  network internal http://controller:9696
openstack endpoint create --region RegionOne \
  network admin http://controller:9696
