#!/bin/sh
source /root/admin-openrc
env
openstack user create --domain default --password pass glance
openstack role add --project service --user glance admin
openstack service create --name glance \
  --description "OpenStack Image" image
openstack endpoint create --region RegionOne \
  image public http://controller:9292
openstack endpoint create --region RegionOne \
  image internal http://controller:9292
openstack endpoint create --region RegionOne \
  image admin http://controller:9292
