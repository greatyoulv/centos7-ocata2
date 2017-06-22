#定义的一些常量
HOSTNAME='/etc/hostname'
HOSTS='/etc/hosts'
ETH0='/etc/sysconfig/network-scripts/ifcfg-eth0'
ETH1='/etc/sysconfig/network-scripts/ifcfg-eth1'

#修改IP地址
#首先读取ifcfg-eth0文件
echo "${ETH0}的内容如下："
cat  ${ETH0}
echo -e "\n"
cat ${ETH1}
echo -e "\n"

sed -i "s/ONBOOT=no/ONBOOT=yes/g" ${ETH0}
sed -i "s/ONBOOT=no/ONBOOT=yes/g" ${ETH1}
sed -i "s/none/static/g" ${ETH0}
sed -i "s/dhcp/static/g" ${ETH0}
sed -i "s/dhcp/none/g" ${ETH1}

sed -i "1c controller" ${HOSTNAME}
cat ${HOSTNAME}

echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
10.0.0.112 controller" > ${HOSTS}

ping -c 4 openstack.org

ping -c 4 controller
