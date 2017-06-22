#!/bin/sh
file1='/etc/httpd/conf/httpd.conf'
sed -i '/ServerName/a ServerName controller' $file1 |grep -n '/^#ServerName' $file1
ln -s /usr/share/keystone/wsgi-keystone.conf /etc/httpd/conf.d/
systemctl enable httpd.service
systemctl start httpd.service
<<<<<<< HEAD
=======
export OS_USERNAME=admin
export OS_PASSWORD=pass
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:35357/v3
export OS_IDENTITY_API_VERSION=3
>>>>>>> 6339b45ddec29f3cab540ccc2df53dc41253e0c6
