#!/bin/bash

wget --quiet --no-check-certificate -P /root https://raw.githubusercontent.com/stuartatmicrosoft/Azure-Linux-Migration-Workshop/master/provision-scripts/provision-stage1.sh
wget --quiet --no-check-certificate -P /root https://raw.githubusercontent.com/stuartatmicrosoft/Azure-Linux-Migration-Workshop/master/provision-scripts/provision-stage2.sh
wget --quiet --no-check-certificate -P /root https://raw.githubusercontent.com/stuartatmicrosoft/Azure-Linux-Migration-Workshop/master/provision-scripts/provision-stage3.sh

chmod 755 /root/provision-stage1.sh
chmod 755 /root/provision-stage2.sh
chmod 755 /root/provision-stage3.sh

bash /root/provision-stage1.sh
bash /root/provision-stage2.sh
bash /root/provision-stage3.sh
