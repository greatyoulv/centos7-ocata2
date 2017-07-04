#!/bin/sh
yum install -y openstack-cinder targetcli python-keystone

file1='/etc/cinder/cinder.conf'

##[database]
sed -i '/^\[database\]/{n;d}' $file1 |grep -n '^\[database\]' $file1
sed -i '/^\[database\]/a connection = mysql+pymysql://cinder:pass@controller/cinder' $file1 |grep -n '^\[database\]' $file1


##[DEFAULT]
sed -i '3040,3050{/^\#transport_url/{n;d}}' $file1 |grep -n '^\#transport_url' $file1
sed -n '3040,3050{/^\#transport_url/p}' $file1 |sed -i '/^\#transport_url/a transport_url = rabbit://openstack:pass@controller' $file1


##[DEFAULT]
sed -i '/^\#auth_strategy/{n;d}' $file1 |grep -n '^\#auth_strategy' $file1
sed -i '/^\#auth_strategy/a auth_strategy = keystone' $file1 |grep -n '^auth_strategy' $file1

##[keystone_authtoken]
#sed -i '/^\[keystone_authtoken\]/{n;d}' $file1 |grep -n '^\[keystone_authtoken\]' $file1
#sed -i '/^\[keystone_authtoken\]/a auth_uri = http://controller:5000\nauth_url = http://controller:35357\nmemcached_servers = controller:11211\nauth_type = password\nproject_domain_name = default\nuser_domain_name = default\nproject_name = service\nusername = cinder\npassword = pass' $file1 |grep -n '^\[keystone_authtoken\]' $file1


##[DEFAULT]
sed -i '/^\#my_ip/{n;d}' $file1 |grep -n '^\#my_ip' $file1
sed -i '/^\#my_ip/a my_ip = 10.0.0.112' $file1 |grep -n '^my_ip' $file1

##[lvm]
echo '[lvm]
volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
volume_group = cinder-volumes
iscsi_protocol = iscsi
iscsi_helper = lioadm' >> $file1


##[DEFAULT]
sed -i '/^\#enabled_backends/{n;d}' $file1 |grep -n '^\#enabled_backends' $file1
sed -i '/^\#enabled_backends/a enabled_backends = lvm' $file1 |grep -n '^enabled_backends' $file1

##[DEFAULT]
sed -i '/^\#glance_api_servers/{n;d}' $file1 |grep -n '^\#glance_api_servers' $file1
sed -i '/^\#glance_api_servers/a glance_api_servers = http://controller:9292' $file1 |grep -n '^glance_api_servers' $file1


##[oslo_concurrency]
sed -i '/^\[oslo_concurrency\]/{n;d}' $file1 |grep -n '^\[oslo_concurrency\]' $file1
sed -i '/^\[oslo_concurrency\]/a lock_path = /var/lib/cinder/tmp' $file1 |grep -n '^\[oslo_concurrency\]' $file1


systemctl enable openstack-cinder-volume.service target.service
systemctl start openstack-cinder-volume.service target.service
