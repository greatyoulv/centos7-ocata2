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

sed -i "s/'BACKEND': 'django.core.cache.backends.locmem.LocMemCache'/'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache'/" $file1

sed -i "1,/'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache'/a 'LOCATION': 'controller:11211',
