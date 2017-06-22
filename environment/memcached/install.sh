#!/bin/sh
yum install memcached python-memcached -y
sed -i 's/OPTIONS="-l 127.0.0.1,::1"/OPTIONS="-l 127.0.0.1,::1,controller"/g' /etc/sysconfig/memcached 
systemctl enable memcached.service
systemctl start memcached.service
