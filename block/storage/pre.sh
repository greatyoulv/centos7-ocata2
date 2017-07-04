#!/bin/sh
yum install -y lvm2
systemctl enable lvm2-lvmetad.service
systemctl start lvm2-lvmetad.service
