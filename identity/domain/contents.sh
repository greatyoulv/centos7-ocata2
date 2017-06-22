#!/bin/sh
openstack project create --domain default \
  --description "Service Project" service
openstack project create --domain default \
  --description "Demo Project" demo
openstack user create --domain default \
  --password pass demo
openstack role create user
openstack role add --project demo --user demo user
