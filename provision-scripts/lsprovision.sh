#!/bin/bash

AZ_USER_NAME=${1}
AZ_USER_PASSWORD=${2}
AZ_TENANT_ID=${3}
AZ_SUBSCRIPTION_ID=${4}
SP_NAME=${5}
SP_SECRET=${6}
SP_OBJECT_ID=${7}
SP_APP_ID=${8}

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

echo AZ_USER_NAME=$AZ_USER_NAME >> /home/student/Desktop/credentials.txt
echo AZ_USER_PASSWORD=$AZ_USER_PASSWORD >> /home/student/Desktop/credentials.txt
echo AZ_TENANT_ID=$AZ_TENANT_ID >> /home/student/Desktop/credentials.txt
echo AZ_SUBSCRIPTION_ID=$AZ_SUBSCRIPTION_ID >> /home/student/Desktop/credentials.txt
echo SP_NAME=$SP_NAME >> /home/student/Desktop/credentials.txt
echo SP_SECRET=$SP_SECRET >> /home/student/Desktop/credentials.txt
echo SP_OBJECT_ID=$SP_OBJECT_ID >> /home/student/Desktop/credentials.txt
echo SP_APP_ID=$SP_APP_ID >> /home/student/Desktop/credentials.txt
echo GUIDE_URL=https://github.com/stuartatmicrosoft/Azure-Linux-Migration-Workshop >> /home/student/Desktop/credentials.txt
chown student:student /home/student/Desktop/credentials.txt
