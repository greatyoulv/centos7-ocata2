#!/bin/sh
sed -i 's/keepcache=0/keepcache=1/' /etc/yum.conf
yum install chrony --downloadonly
yum install centos-release-openstack-ocata  --downloadonly
yum install -y centos-release-openstack-ocata
yum upgrade --downloadonly
yum install python-openstackclient --downloadonly
yum install openstack-selinux --downloadonly
yum install mariadb mariadb-server python2-PyMySQL  --downloadonly
yum install rabbitmq-server  --downloadonly
yum install memcached python-memcached  --downloadonly
yum install openstack-keystone httpd mod_wsgi  --downloadonly
yum install openstack-glance  --downloadonly
yum install openstack-nova-api openstack-nova-conductor  openstack-nova-console openstack-nova-novncproxy  openstack-nova-scheduler openstack-nova-placement-api  --downloadonly
yum install openstack-nova-compute  --downloadonly
yum install openstack-neutron openstack-neutron-ml2 openstack-neutron-linuxbridge ebtables  --downloadonly
yum install openstack-neutron-linuxbridge ebtables ipset  --downloadonly
yum install openstack-dashboard  --downloadonly
yum install openstack-cinder  --downloadonly
yum install lvm2  --downloadonly
yum install openstack-cinder targetcli python-keystone  --downloadonly
