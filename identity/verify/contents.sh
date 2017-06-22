#!/bin/sh
file1=/etc/keystone/keystone-paste.ini
sed -i '/admin_token_auth/d' $file1 | grep -n '/^\[pipeline:public_api]' $file1
