#!/bin/sh
yum install -y openstack-nova-api openstack-nova-conductor \
  openstack-nova-console openstack-nova-novncproxy \
  openstack-nova-scheduler openstack-nova-placement-api

file1='/etc/nova/nova.conf'
file2='/etc/httpd/conf.d/00-nova-placement-api.conf'

##[Default]
sed -i '/^\#enabled_apis/{n;d}' $file1 |grep -n '^\#enabled_apis' $file1
sed -i '/^\#enabled_apis/a enabled_apis = osapi_compute,metadata' $file1 |grep -n '^enabled_apis' $file1

##[api_database]
sed -i '/^\[api_database\]/{n;d}' $file1 |grep -n '^\[api_database\]' $file1
sed -i '/^\[api_database\]/a connection = mysql+pymysql://nova:pass@controller/nova_api' $file1 |grep -n '^\[api_database\]' $file1



##[database]
sed -i '/^\[database\]/{n;d}' $file1 |grep -n '^\[database\]' $file1
sed -i '/^\[database\]/a connection = mysql+pymysql://nova:pass@controller/nova' $file1 |grep -n '^\[database\]' $file1


##[DEFAULT]
sed -i '3020,3030{/^\#transport_url/{n;d}}' $file1 |grep -n '^\#transport_url' $file1
sed -n '3020,3030{/^\#transport_url/p}' $file1 |sed -i '/^\#transport_url/a transport_url = rabbit://openstack:pass@controller' $file1

##[api]
sed -i '/^\[api\]/{n;d}' $file1 |grep -n '^\[api\]' $file1
sed -i '/^\[api\]/a auth_strategy = keystone' $file1 |grep -n '^\[api\]' $file1


##[keystone_authtoken]
sed -i '/^\[keystone_authtoken\]/{n;d}' $file1 |grep -n '^\[keystone_authtoken\]' $file1
sed -i '/^\[keystone_authtoken\]/a auth_uri = http://controller:5000\nauth_url = http://controller:35357\nmemcached_servers = controller:11211\nauth_type = password\nproject_domain_name = default\nuser_domain_name = default\nproject_name = service\nusername = nova\npassword = pass' $file1 |grep -n '^\[keystone_authtoken\]' $file1


##[DEFAULT]
sed -i '/^\#my_ip/{n;d}' $file1 |grep -n '^\#my_ip' $file1
sed -i '/^\#my_ip/a my_ip = 192.168.100.100' $file1 |grep -n '^my_ip' $file1



##[DEFAULT]
sed -i '2300,2310{/^\#use_neutron/{n;d}}' $file1 |grep -n '^\#use_neutron' $file1
sed -i '2300,2310{/^\#use_neutron/p}' $file1 |sed -i '/^\#use_neutron/a use_neutron = True' $file1

sed -i '2460,2470{/^\#firewall_driver/{n;d}}' $file1 |grep -n '^\#firewall_driver' $file1
sed -i '2460,2470{/^\#firewall_driver/p}' $file1 |sed -i '/^\#firewall_driver/a firewall_driver = nova.virt.firewall.NoopFirewallDriver' $file1


##[vnc]
sed -i '9650,9660{/^\#enabled=true/{n;d}}' $file1 |grep -n '^\#enabled=true' $file1
sed -i '9650,9660{/^\#enabled=true/p}' $file1 |sed -i '/^\#enabled=true/a enabled = true\nvncserver_listen = $my_ip\nvncserver_proxyclient_address = $my_ip' $file1 |grep -n '^\\' $file1



##[glance]
sed -i '/^\[glance\]/{n;d}' $file1 |grep -n '^\[glance\]' $file1
sed -i '/^\[glance\]/a api_servers = http://controller:9292' $file1 |grep -n '^\[glance\]' $file1




##[oslo_concurrency]
sed -i '/^\[oslo_concurrency\]/{n;d}' $file1 |grep -n '^\[oslo_concurrency\]' $file1
sed -i '/^\[oslo_concurrency\]/a lock_path = /var/lib/nova/tmp' $file1 |grep -n '^\[oslo_concurrency\]' $file1


##[placement]
sed -i '/^\[placement\]/{n;d}' $file1 |grep -n '^\[placement\]' $file1
sed -i '/^\[placement\]/a os_region_name = RegionOne\nproject_domain_name = Default\nproject_name = service\nauth_type = password\nuser_domain_name = Default\nauth_url = http://controller:35357/v3\nusername = placement\npassword = pass' $file1 |grep -n '^\[placement\]' $file1

echo -e "\n<Directory /usr/bin>
   <IfVersion >= 2.4>
      Require all granted
   </IfVersion>
   <IfVersion < 2.4>
      Order allow,deny
      Allow from all
   </IfVersion>
</Directory>" >> $file2

systemctl restart httpd
su -s /bin/sh -c "nova-manage api_db sync" nova
su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova
su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova
su -s /bin/sh -c "nova-manage db sync" nova
nova-manage cell_v2 list_cells
systemctl enable openstack-nova-api.service \
  openstack-nova-consoleauth.service openstack-nova-scheduler.service \
  openstack-nova-conductor.service openstack-nova-novncproxy.service
systemctl start openstack-nova-api.service \
  openstack-nova-consoleauth.service openstack-nova-scheduler.service \
  openstack-nova-conductor.service openstack-nova-novncproxy.service
