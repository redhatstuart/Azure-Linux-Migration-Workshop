#!/bin/bash

AZURE_DC="eastus2"
SHORT="$(echo $AZURE_DC | cut -c1-4)"
COUNTER="1"
RG_NAME="liftshift-$SHORT-$COUNTER"
NEWHOST="liftshift-source-$COUNTER"
NSG=$NEWHOST
NSG+="NSG"

#echo $AZURE_DC
#echo $SHORT
#echo $RG_NAME
#echo $COUNTER
#echo $NEWHOST
#echo $NSG

echo "**************************************************************"
echo Creating resource group $RG_NAME
az group create -n $RG_NAME -l $AZURE_DC
echo "**************************************************************"
echo "Creating source host #$COUNTER virtual machine in resource group $RG_NAME"
az vm create --resource-group $RG_NAME --name $NEWHOST --image OpenLogic:CentOS-LVM:7-LVM:7.5.20180823 --public-ip-address-dns-name $NEWHOST --authentication-type password --storage-sku Standard_LRS --size Standard_E4_v3 --admin-username lsadmin --admin-password LiftShift123!
echo "**************************************************************"
echo "Creating NSG rule to allow inbound SSH requests on port 2112"
az network nsg rule create --resource-group $RG_NAME --nsg-name $NSG --name allow-ssh2112 --description "Allow SSH Port 2112" --access Allow --protocol Tcp --direction Inbound --priority 110 --source-address-prefix "*" --source-port-range "*" --destination-address-prefix "*" --destination-port-range "2112"
echo "**************************************************************"
echo "Creating NSG rule to allow inbound NOVNC requests on port 6080"
az network nsg rule create --resource-group $RG_NAME --nsg-name $NSG --name allow-novnc6080 --description "Allow noVNC Port 6080" --access Allow --protocol Tcp --direction Inbound --priority 120 --source-address-prefix "*" --source-port-range "*" --destination-address-prefix "*" --destination-port-range "6080"
echo "Done"
echo "Login as: lsadmin"
echo "Password is: LiftShift123!"
