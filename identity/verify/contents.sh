#!/bin/sh
file1=/etc/keystone/keystone-paste.ini
<<<<<<< HEAD
sed -i 's/admin_token_auth/ /g' $file1 | grep -n '^\[pipeline:public_api]' $file1
=======
sed -i 's/admin_token_auth/ /g' $file1
>>>>>>> 90d27c0f5536aabc6cc6f5cb97d4530385f6e69c
unset OS_AUTH_URL OS_PASSWORD
openstack --os-auth-url http://controller:35357/v3 \
  --os-project-domain-name default --os-user-domain-name default \
  --os-project-name admin --os-username admin token issue
openstack --os-auth-url http://controller:5000/v3 \
  --os-project-domain-name default --os-user-domain-name default \
  --os-project-name demo --os-username demo token issue

