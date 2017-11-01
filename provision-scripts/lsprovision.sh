#!/bin/bash

wget --quiet --no-check-certificate -P /root https://raw.githubusercontent.com/stuartatmicrosoft/Azure-Linux-Migration-Workshop/master/provision-scripts/provision-stage1.sh
wget --quiet --no-check-certificate -P /root https://raw.githubusercontent.com/stuartatmicrosoft/Azure-Linux-Migration-Workshop/master/provision-scripts/provision-stage2.sh
wget --quiet --no-check-certificate -P /root https://raw.githubusercontent.com/stuartatmicrosoft/Azure-Linux-Migration-Workshop/master/provision-scripts/provision-stage3.sh

chmod 755 /root/provision-stage1.sh
chmod 755 /root/provision-stage2.sh
chmod 755 /root/provision-stage3.sh

echo "`date` -- Calling Provision Stage 1" >>/root/lsprovision.log
bash /root/provision-stage1.sh
echo "`date` -- Provision Stage 1 script complete" >>/root/lsprovision.log
echo " " >> /root/lsprovision.log
echo "`date` -- Calling Provision Stage 2" >>/root/lsprovision.log
bash /root/provision-stage2.sh
echo "`date` -- Provision Stage 2 script complete" >>/root/lsprovision.log
echo " " >> /root/lsprovision.log
echo "`date` -- Calling Provision Stage 3" >>/root/lsprovision.log
bash /root/provision-stage3.sh
echo "`date` -- Provision Stage 3 script complete" >>/root/lsprovision.log
