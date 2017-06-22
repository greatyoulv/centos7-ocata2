#!/bin/sh
<<<<<<< HEAD
yum install chrony -y
=======
yum install chrony
>>>>>>> 6339b45ddec29f3cab540ccc2df53dc41253e0c6
systemctl enable chronyd.service
systemctl start chronyd.service
chronyc sources
