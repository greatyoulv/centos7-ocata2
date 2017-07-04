#!/bin/sh
mysql -uroot -ppass -e"CREATE DATABASE cinder;"
mysql -uroot -ppass -e"GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' \
  IDENTIFIED BY 'pass';"
mysql -uroot -ppass -e"GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' \
  IDENTIFIED BY 'pass';"
source /root/admin-openrc
openstack user create --domain default --password pass cinder
openstack role add --project service --user cinder admin
openstack service create --name cinderv2 \
  --description "OpenStack Block Storage" volumev2
openstack service create --name cinderv3 \
  --description "OpenStack Block Storage" volumev3
openstack endpoint create --region RegionOne \
  volumev2 public http://controller:8776/v2/%\(project_id\)s
openstack endpoint create --region RegionOne \
  volumev2 internal http://controller:8776/v2/%\(project_id\)s
openstack endpoint create --region RegionOne \
  volumev2 admin http://controller:8776/v2/%\(project_id\)s
openstack endpoint create --region RegionOne \
  volumev3 public http://controller:8776/v3/%\(project_id\)s
openstack endpoint create --region RegionOne \
  volumev3 internal http://controller:8776/v3/%\(project_id\)s
openstack endpoint create --region RegionOne \
  volumev3 admin http://controller:8776/v3/%\(project_id\)s
