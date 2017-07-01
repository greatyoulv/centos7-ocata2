#!/bin/sh
file1='/etc/neutron/metadata_agent.ini'
file2='/etc/nova/nova.conf'

##[Default]
sed -i '/^\#nova_metadata_ip/{n;d}' $file1 |grep -n '^\#nova_metadata_ip' $file1
sed -i '/^\#nova_metadata_ip/a nova_metadata_ip = controller' $file1 |grep -n '^nova_metadata_ip' $file1

sed -i '/^\#metadata_proxy_shared_secret/{n;d}' $file1 |grep -n '^\#metadata_proxy_shared_secret' $file1
sed -i '/^\#metadata_proxy_shared_secret/a metadata_proxy_shared_secret = pass' $file1 |grep -n '^metadata_proxy_shared_secret' $file1


##[neutron]
sed -i '/^\[neutron\]/{n;d}' $file2 |grep -n '^\[neutron\]' $file2
sed -i '/^\[neutron\]/a url = http://controller:9696\nauth_url = http://controller:35357\nauth_type = password\nproject_domain_name = default\nuser_domain_name = default\nregion_name = RegionOne\nproject_name = service\nusername = neutron\npassword = pass\nservice_metadata_proxy = true\nmetadata_proxy_shared_secret = pass' $file2 |grep -n '^[neutron\]' $file2



ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini

su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf \
  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron

systemctl restart openstack-nova-api.service
systemctl enable neutron-server.service \
  neutron-linuxbridge-agent.service neutron-dhcp-agent.service \
  neutron-metadata-agent.service
systemctl start neutron-server.service \
  neutron-linuxbridge-agent.service neutron-dhcp-agent.service \
  neutron-metadata-agent.service
systemctl enable neutron-l3-agent.service
systemctl start neutron-l3-agent.service
