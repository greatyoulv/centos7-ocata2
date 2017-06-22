#!/bin/sh
yum install rabbitmq-server -y
systemctl enable rabbitmq-server.service
systemctl start rabbitmq-server.service
rabbitmqctl add_user openstack pass
rabbitmqctl set_permissions openstack ".*" ".*" ".*"
