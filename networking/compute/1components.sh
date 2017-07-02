#!/bin/sh
yum install -y openstack-neutron-linuxbridge ebtables ipset

file1='/etc/neutron/neutron.conf'
##[DEFAULT]
sed -i '570,580{/^\#transport_url/{n;d}}' $file1 |grep -n '^\#transport_url' $file1
sed -n '570,580{/^\#transport_url/p}' $file1 |sed -i '/^\#transport_url/a transport_url = rabbit://openstack:pass@controller' $file1

##[Default]
sed -i '/^\#auth_strategy/{n;d}' $file1 |grep -n '^\#auth_strategy' $file1
sed -i '/^\#auth_strategy/a auth_strategy = keystone' $file1 |grep -n '^auth_strategy' $file1

##[keystone_authtoken]
#sed -i '/^\[keystone_authtoken\]/{n;d}' $file1 |grep -n '^\[keystone_authtoken\]' $file1
#sed -i '/^\[keystone_authtoken\]/a auth_uri = http://controller:5000\nauth_url = http://controller:35357\nmemcached_servers = controller:11211\nauth_type = password\nproject_domain_name = default\nuser_domain_name = default\nproject_name = service\nusername = neutron\npassword = pass' $file1 |grep -n '^\[keystone_authtoken\]' $file1

##[oslo_concurrency]
sed -i '/^\[oslo_concurrency\]/{n;d}' $file1 |grep -n '^\[oslo_concurrency\]' $file1
sed -i '/^\[oslo_concurrency\]/a lock_path = /var/lib/neutron/tmp' $file1 |grep -n '^\[oslo_concurrency\]' $file1
