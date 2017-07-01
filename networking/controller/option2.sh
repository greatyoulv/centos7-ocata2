#!/bin/sh
yum install -y openstack-neutron openstack-neutron-ml2 \
  openstack-neutron-linuxbridge ebtables

file1='/etc/neutron/neutron.conf'
file2=' /etc/neutron/plugins/ml2/ml2_conf.ini'
file3=' /etc/neutron/plugins/ml2/linuxbridge_agent.ini'
file4='/etc/neutron/l3_agent.ini'
file5='/etc/neutron/dhcp_agent.ini'

##[database]
sed -i '/^\[database\]/{n;d}' $file1 |grep -n '^\[database\]' $file1
sed -i '/^\[database\]/a connection = mysql+pymysql://neutron:pass@controller/neutron' $file1 |grep -n '^\[database\]' $file1

##[Default]
sed -i '/^\#core_plugin/{n;d}' $file1 |grep -n '^\#core_plugin' $file1
sed -i '/^\#core_plugin/a core_plugin = ml2' $file1 |grep -n '^core_plugin' $file1

sed -i '/^\#service_plugins/{n;d}' $file1 |grep -n '^\#service_plugins' $file1
sed -i '/^\#service_plugins/a service_plugins = router' $file1 |grep -n '^service_plugins' $file1

sed -i '/^\#allow_overlapping_ips/{n;d}' $file1 |grep -n '^\#allow_overlapping_ips' $file1
sed -i '/^\#allow_overlapping_ips/a allow_overlapping_ips = true' $file1 |grep -n '^allow_overlapping_ips' $file1

##[DEFAULT]
sed -i '570,580{/^\#transport_url/{n;d}}' $file1 |grep -n '^\#transport_url' $file1
sed -n '570,580{/^\#transport_url/p}' $file1 |sed -i '/^\#transport_url/a transport_url = rabbit://openstack:pass@controller' $file1

##[Default]
sed -i '/^\#auth_strategy/{n;d}' $file1 |grep -n '^\#auth_strategy' $file1
sed -i '/^\#auth_strategy/a auth_strategy = keystone' $file1 |grep -n '^auth_strategy' $file1

##[keystone_authtoken]
sed -i '/^\[keystone_authtoken\]/{n;d}' $file1 |grep -n '^\[keystone_authtoken\]' $file1
sed -i '/^\[keystone_authtoken\]/a auth_uri = http://controller:5000\nauth_url = http://controller:35357\nmemcached_servers = controller:11211\nauth_type = password\nproject_domain_name = default\nuser_domain_name = default\nproject_name = service\nusername = neutron\npassword = pass' $file1 |grep -n '^\[keystone_authtoken\]' $file1

##[DEFAULT]
sed -i '/^\#notify_nova_on_port_status_changes/{n;d}' $file1 |grep -n '^\#notify_nova_on_port_status_changes' $file1
sed -i '/^\#notify_nova_on_port_status_changes/a notify_nova_on_port_status_changes = true' $file1 |grep -n '^notify_nova_on_port_status_changes' $file1

sed -i '/^\#notify_nova_on_port_data_changes/{n;d}' $file1 |grep -n '^\#notify_nova_on_port_data_changes' $file1
sed -i '/^\#notify_nova_on_port_data_changes/a notify_nova_on_port_data_changes = true' $file1 |grep -n '^notify_nova_on_port_data_changes' $file1

##[nova]
sed -i '/^\[nova\]/{n;d}' $file1 |grep -n '^\[nova\]' $file1
sed -i '/^\\[nova\]/a auth_url = http://controller:35357\nauth_type = password\nproject_domain_name = default\nuser_domain_name = default\nregion_name = RegionOne\nproject_name = service\nusername = nova\npassword = pass' $file1 |grep -n '^\[nova\]' $file1

##[oslo_concurrency]
sed -i '/^\[oslo_concurrency\]/{n;d}' $file1 |grep -n '^\[oslo_concurrency\]' $file1
sed -i '/^\[oslo_concurrency\]/a lock_path = /var/lib/neutron/tmp' $file1 |grep -n '^\[oslo_concurrency\]' $file1





##[ml2]
sed -i '/^\#type_drivers/{n;d}' $file2 |grep -n '^\#type_drivers' $file2
sed -i '/^\#type_drivers/a type_drivers = flat,vlan,vxlan' $file2 |grep -n '^type_drivers' $file2

sed -i '/^\#tenant_network_types/{n;d}' $file2 |grep -n '^\#tenant_network_types' $file2
sed -i '/^\#tenant_network_types/a tenant_network_types = vxlan' $file2 |grep -n '^tenant_network_types' $file2

sed -i '/^\#mechanism_drivers/{n;d}' $file2 |grep -n '^\#mechanism_drivers' $file2
sed -i '/^\#mechanism_drivers/a mechanism_drivers = linuxbridge,l2population' $file2 |grep -n '^mechanism_drivers' $file2

sed -i '/^\#extension_drivers/{n;d}' $file2 |grep -n '^\#extension_drivers' $file2
sed -i '/^\#extension_drivers/a extension_drivers = port_security' $file2 |grep -n '^extension_drivers' $file2


##[ml2_type_flat]
sed -i '/^\#flat_networks/{n;d}' $file2 |grep -n '^\#flat_networks' $file2
sed -i '/^\#flat_networks/a flat_networks = provider' $file2 |grep -n '^flat_networks' $file2


##[ml2_type_vxlan]
sed -i '224,234{/^\#vni_ranges/{n;d}}' $file2 |grep -n '^\#vni_ranges' $file2
sed -i '224,234{/^\#vni_ranges/p}' $file2 |sed -i '/^\#vni_ranges/a vni_ranges = 1:1000' $file2

##[securitygroup]
sed -i '/^\#enable_ipset/{n;d}' $file2 |grep -n '^\#enable_ipset' $file2
sed -i '/^\#enable_ipset/a enable_ipset = true' $file2 |grep -n '^enable_ipset' $file2





##[linux_bridge]
sed -i '/^\#physical_interface_mappings/{n;d}' $file3 |grep -n '^\#physical_interface_mappings' $file3
sed -i '/^\#physical_interface_mappings/a physical_interface_mappings = provider:eth1' $file3 |grep -n '^physical_interface_mappings' $file3


##[vxlan]
sed -i '/^\#enable_vxlan/{n;d}' $file3 |grep -n '^\#enable_vxlan' $file3
sed -i '/^\#enable_vxlan/a enable_vxlan = true' $file3 |grep -n '^enable_vxlan' $file3

sed -i '/^\#local_ip/{n;d}' $file3 |grep -n '^\#local_ip' $file3
sed -i '/^\#local_ip/a local_ip = 192.168.100.100' $file3 |grep -n '^local_ip' $file3

sed -i '/^\#l2_population/{n;d}' $file3 |grep -n '^\#l2_population' $file3
sed -i '/^\#l2_population/a l2_population = true' $file3 |grep -n '^l2_population' $file3


##[securitygroup]
sed -i '/^\#enable_security_group/{n;d}' $file3 |grep -n '^\#enable_security_group' $file3
sed -i '/^\#enable_security_group/a enable_security_group = true' $file3 |grep -n '^enable_security_group' $file3

sed -i '/^\#firewall_driver/{n;d}' $file3 |grep -n '^\#firewall_driver' $file3
sed -i '/^\#firewall_driver/a firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver' $file3 |grep -n '^firewall_driver' $file3


##[DEFAULT]
sed -i '/^\#interface_driver/{n;d}' $file4 |grep -n '^\#interface_driver' $file4
sed -i '/^\#interface_driver/a interface_driver = linuxbridge' $file4 |grep -n '^interface_driver' $file4




##[DEFAULT]
sed -i '/^\#interface_driver/{n;d}' $file5 |grep -n '^\#interface_driver' $file5
sed -i '/^\#interface_driver/a interface_driver = linuxbridge' $file5 |grep -n '^interface_driver' $file5

sed -i '/^\#dhcp_driver/{n;d}' $file5 |grep -n '^\#dhcp_driver' $file5
sed -i '/^\#dhcp_driver/a dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq' $file5 |grep -n '^dhcp_driver' $file5

sed -i '/^\#enable_isolated_metadata/{n;d}' $file5 |grep -n '^\#enable_isolated_metadata' $file5
sed -i '/^\#enable_isolated_metadata/a enable_isolated_metadata = true' $file5 |grep -n '^enable_isolated_metadata' $file5

