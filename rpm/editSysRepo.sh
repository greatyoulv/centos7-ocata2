#!/bin/sh
yum clean all
mv /etc/yum.repos.d/* /home
cp ./Centos-Local.repo /etc/yum.repos.d/
