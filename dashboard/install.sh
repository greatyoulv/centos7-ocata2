#!/bin/sh
yum install -y openstack-dashboard
file1='/etc/openstack-dashboard/local_settings'

##OPENSTACK_HOST
sed -i 's/^OPENSTACK_HOST/\#OPENSTACK_HOST/g' $file1
sed -i '/^\#OPENSTACK_HOST/a OPENSTACK_HOST = \"controller\"' $file1 |grep -n '^OPENSTACK_HOST' $file1

##ALLOWED_HOSTS
sed -i 's/^ALLOWED_HOST/\#ALLOWED_HOST/g' $file1
sed -i '/^\#ALLOWED_HOST/a ALLOWED_HOST = \['*'\]' $file1 |grep -n '^ALLOWED_HOST' $file1

##SESSION_ENGINE
sed -i "N;/^CACHES/iSESSION_ENGINE = 'django.contrib.sessions.backends.cache'" $file1

##CACHES
sed -i "s/'BACKEND': 'django.core.cache.backends.locmem.LocMemCache'/'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache'/" $file1

#sed -i '145,155{/BACKEND/{n;d}}' $file1 |grep -n 'BACKEND' $file1
sed -n '145,155{/BACKEND/p}' $file1 |sed -i "/BACKEND/a	'LOCATION': 'controller:11211'," $file1

sed -i '180,190s/v2.0/v3/' $file1


sed -i '/^\#OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT/{n;d}' $file1
sed -i '/^\#OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT/a OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True' $file1 |grep -n '^OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT' $file1

echo '\nOPENSTACK_API_VERSIONS = {
    "identity": 3,
    "image": 2,
    "volume": 2,
}' >> $file1

sed -i '/^\#OPENSTACK_KEYSTONE_DEFAULT_DOMAIN/{n;d}' $file1
sed -i '/^\#OPENSTACK_KEYSTONE_DEFAULT_DOMAIN/a OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = "Default"' $file1 |grep -n '^OPENSTACK_KEYSTONE_DEFAULT_DOMAIN' $file1

sed -i '/^\#OPENSTACK_KEYSTONE_DEFAULT_ROLE/{n;d}' $file1
sed -i '/^\#OPENSTACK_KEYSTONE_DEFAULT_ROLE/a OPENSTACK_KEYSTONE_DEFAULT_ROLE = "user"' $file1 |grep -n '^OPENSTACK_KEYSTONE_DEFAULT_ROLE' $file1

systemctl restart httpd.service memcached.service
