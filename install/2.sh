#!/bin/sh
yum install python-openstackclient -y
yum install openstack-selinux -y
yum install mariadb mariadb-server python2-PyMySQLa -y
yum install rabbitmq-server -y
yum install memcached python-memcached -y
yum install openstack-keystone httpd mod_wsgi -y
yum install openstack-glance -y
yum install openstack-nova-api openstack-nova-conductor \
  openstack-nova-console openstack-nova-novncproxy \
  openstack-nova-scheduler openstack-nova-placement-api -y
yum install openstack-nova-compute -y
yum install openstack-neutron openstack-neutron-ml2 \
  openstack-neutron-linuxbridge ebtables -y
yum install openstack-neutron-linuxbridge ebtables ipset -y
yum install openstack-dashboard -y

