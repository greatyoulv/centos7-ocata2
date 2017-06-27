#!/bin/sh
yum install openstack-glance -y
file1='/etc/glance/glance-api.conf'
file2='/etc/glance/glance-registry.conf'

##[database]
sed -i '/^\[database\]/{n;d}' $file1 |grep -n '^\[database\]' $file1
sed -i '/^\[database\]/a connection = mysql+pymysql://glance:pass@controller/glance' $file1 |grep -n '^\[database\]' $file1


##[keystone_authtoken]
sed -i '/^\[keystone_authtoken\]/{n;d}' $file1 |grep -n '^\[keystone_authtoken\]' $file1
sed -i '/^\[keystone_authtoken\]/a auth_uri = http://controller:5000\nauth_url = http://controller:35357\nmemcached_servers = controller:11211\nauth_type = password\nproject_domain_name = default\nuser_domain_name = default\nproject_name = service\nusername = glance\npassword = pass' $file1 |grep -n '^\[keystone_authtoken\]' $file1

##[paste_deploy]
sed -i '/^\[paste_deploy\]/{n;d}' $file1 |grep -n '^\[paste_deploy\]' $file1
sed -i '/^\[paste_deploy\]/a flavor = keystone' $file1 |grep -n '^\[paste_deploy\]' $file1

##[glance_store]
sed -i '/^\[glance_store\]/{n;d}' $file1 |grep -n '^\[glance_store\]' $file1
sed -i '/^\[glance_store\]/a stores = file,http\ndefault_store = file\nfilesystem_store_datadir = /var/lib/glance/images/' $file1 |grep -n '^\[glance_store\]' $file1


##[database]
sed -i '/^\[database\]/{n;d}' $file2 |grep -n '^\[database\]' $file2
sed -i '/^\[database\]/a connection = mysql+pymysql://glance:pass@controller/glance' $file2 |grep -n '^\[database\]' $file2

##[keystone_authtoken]
sed -i '/^\[keystone_authtoken\]/{n;d}' $file2 |grep -n '^\[keystone_authtoken\]' $file2
sed -i '/^\[keystone_authtoken\]/a auth_uri = http://controller:5000\nauth_url = http://controller:35357\nmemcached_servers = controller:11211\nauth_type = password\nproject_domain_name = default\nuser_domain_name = default\nproject_name = service\nusername = glance\npassword = pass' $file2 |grep -n '^\[keystone_authtoken\]' $file2

##[paste_deploy]
sed -i '/^\[paste_deploy\]/{n;d}' $file2 |grep -n '^\[paste_deploy\]' $file2
sed -i '/^\[paste_deploy\]/a flavor = keystone' $file2 |grep -n '^\[paste_deploy\]' $file2

su -s /bin/sh -c "glance-manage db_sync" glance

systemctl enable openstack-glance-api.service \
  openstack-glance-registry.service

systemctl start openstack-glance-api.service \
  openstack-glance-registry.service
