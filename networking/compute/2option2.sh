#!/bin/sh
file1='/etc/neutron/plugins/ml2/linuxbridge_agent.ini'

##[linux_bridge]
sed -i '/^\#physical_interface_mappings/{n;d}' $file1 |grep -n '^\#physical_interface_mappings' $file1
sed -i '/^\#physical_interface_mappings/a physical_interface_mappings = provider:eth1' $file1 |grep -n '^physical_interface_mappings' $file1


##[vxlan]
sed -i '/^\#enable_vxlan/{n;d}' $file1 |grep -n '^\#enable_vxlan' $file1
sed -i '/^\#enable_vxlan/a enable_vxlan = true' $file1 |grep -n '^enable_vxlan' $file1

sed -i '/^\#local_ip/{n;d}' $file1 |grep -n '^\#local_ip' $file1
sed -i '/^\#local_ip/a local_ip = 192.168.100.100' $file1 |grep -n '^local_ip' $file1

sed -i '/^\#l2_population/{n;d}' $file1 |grep -n '^\#l2_population' $file1
sed -i '/^\#l2_population/a l2_population = true' $file1 |grep -n '^l2_population' $file1


##[securitygroup]
sed -i '/^\#enable_security_group/{n;d}' $file1 |grep -n '^\#enable_security_group' $file1
sed -i '/^\#enable_security_group/a enable_security_group = true' $file1 |grep -n '^enable_security_group' $file1

sed -i '/^\#firewall_driver/{n;d}' $file1 |grep -n '^\#firewall_driver' $file1
sed -i '/^\#firewall_driver/a firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver' $file1 |grep -n '^firewall_driver' $file1

