#!/bin/sh
#sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
#setenforce 0
systemctl stop firewalld.service
systemctl disable firewalld.service

