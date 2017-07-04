#!/bin/sh
yum install -y openstack-cinder

file1='/etc/cinder/cinder.conf'
file2='/etc/nova/nova.conf'

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
sed -i '/^\[keystone_authtoken\]/{n;d}' $file1 |grep -n '^\[keystone_authtoken\]' $file1
sed -i '/^\[keystone_authtoken\]/a auth_uri = http://controller:5000\nauth_url = http://controller:35357\nmemcached_servers = controller:11211\nauth_type = password\nproject_domain_name = default\nuser_domain_name = default\nproject_name = service\nusername = cinder\npassword = pass' $file1 |grep -n '^\[keystone_authtoken\]' $file1


##[DEFAULT]
sed -i '/^\#my_ip/{n;d}' $file1 |grep -n '^\#my_ip' $file1
sed -i '/^\#my_ip/a my_ip = 10.0.0.112' $file1 |grep -n '^my_ip' $file1

##[oslo_concurrency]
sed -i '/^\[oslo_concurrency\]/{n;d}' $file1 |grep -n '^\[oslo_concurrency\]' $file1
sed -i '/^\[oslo_concurrency\]/a lock_path = /var/lib/nova/tmp' $file1 |grep -n '^\[oslo_concurrency\]' $file1



su -s /bin/sh -c "cinder-manage db sync" cinder



##[cinder]
sed -i '4030,4040{/^\#os_region_name/{n;d}}' $file2 |grep -n '^\#os_region_name' $file2
sed -n '4030,4040{/^\#os_region_name/p}' $file2 |sed -i '/^\#os_region_name/a os_region_name = RegionOne' $file2


systemctl restart openstack-nova-api.service
systemctl enable openstack-cinder-api.service openstack-cinder-scheduler.service
systemctl start openstack-cinder-api.service openstack-cinder-scheduler.service


