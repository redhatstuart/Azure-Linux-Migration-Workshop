#!/bin/bash

wget --quiet --no-check-certificate -P /root https://raw.githubusercontent.com/stuartatmicrosoft/Azure-Linux-Migration-Workshop/master/provision-scripts/provision-stage1.sh
wget --quiet --no-check-certificate -P /root https://raw.githubusercontent.com/stuartatmicrosoft/Azure-Linux-Migration-Workshop/master/provision-scripts/provision-stage2.sh
wget --quiet --no-check-certificate -P /root https://raw.githubusercontent.com/stuartatmicrosoft/Azure-Linux-Migration-Workshop/master/provision-scripts/provision-stage3.sh

chmod 755 /root/provision-stage1.sh
chmod 755 /root/provision-stage2.sh
chmod 755 /root/provision-stage3.sh

echo "Calling Provision Stage 1 at `date`" >>/root/lsprovision.log
bash /root/provision-stage1.sh
echo "Provision Stage 1 script complete at `date`" >>/root/lsprovision.log
echo "Calling Provision Stage 2 at `date`" >>/root/lsprovision.log
bash /root/provision-stage2.sh
echo "Provision Stage 2 script complete at `date`" >>/root/lsprovision.log
echo "Calling Provision Stage 3 at `date`" >>/root/lsprovision.log
bash /root/provision-stage3.sh
echo "Provision Stage 3 script complete at `date`" >>/root/lsprovision.log
