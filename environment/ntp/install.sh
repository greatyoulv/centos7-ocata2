#!/bin/sh
yum install chrony -y
yum install chrony
systemctl enable chronyd.service
systemctl start chronyd.service
chronyc sources
