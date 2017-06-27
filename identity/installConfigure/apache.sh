#!/bin/sh
file1='/etc/httpd/conf/httpd.conf'
sed -i '/^\#ServerName/{n;d}' $file1 |grep -n '^#ServerName' $file1
sed -i '/^\#ServerName/a ServerName controller' $file1 |grep -n '^#ServerName' $file1
ln -s /usr/share/keystone/wsgi-keystone.conf /etc/httpd/conf.d/
systemctl enable httpd.service
systemctl start httpd.service
