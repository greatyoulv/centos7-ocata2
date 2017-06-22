#!/bin/sh
file='/etc/keystone/keystone.conf'
yum install openstack-keystone httpd mod_wsgi -y
##[database]
sed -i '/\[database\]/{n;d}' $file |grep -n '/^\[database\]' $file
sed -i '/\[database\]/a connection = mysql+pymysql://keystone:pass@controller/keystone' $file |grep -n '/^\[database\]' $file
##[token]
sed -i '/\[token\]/{n;d}' $file |grep -n '/^\[token\]' $file
sed -i '/\[token\]/a provider = fernet' $file |grep -n '/^\[token\]' $file
su -s /bin/sh -c "keystone-manage db_sync" keystone
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
keystone-manage bootstrap --bootstrap-password pass \
  --bootstrap-admin-url http://controller:35357/v3/ \
  --bootstrap-internal-url http://controller:5000/v3/ \
  --bootstrap-public-url http://controller:5000/v3/ \
  --bootstrap-region-id RegionOne
