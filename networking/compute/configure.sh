#!/bin/sh
file1='/etc/nova/nova.conf'

##[neutron]
#sed -i '/^\[neutron\]/{n;d}' $file1 |grep -n '^\[neutron\]' $file1
#sed -i '/^\[neutron\]/a url = http://controller:9696\nauth_url = http://controller:35357\nauth_type = password\nproject_domain_name = default\nuser_domain_name = default\nregion_name = RegionOne\nproject_name = service\nusername = neutron\npassword = pass\nservice_metadata_proxy = true\nmetadata_proxy_shared_secret = pass' $file1 |grep -n '^[neutron\]' $file1

systemctl restart openstack-nova-compute.service
systemctl enable neutron-linuxbridge-agent.service
systemctl start neutron-linuxbridge-agent.service
