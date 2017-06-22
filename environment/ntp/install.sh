#!/bin/sh
yum install chrony -y
systemctl enable chronyd.service
systemctl start chronyd.service
chronyc sources
