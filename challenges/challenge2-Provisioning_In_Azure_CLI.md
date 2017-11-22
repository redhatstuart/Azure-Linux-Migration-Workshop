# Provisioning Linux resources in Azure using the Azure CLI

## Expected Outcome

This challenge will serve as an extension to Challenge 1.  As part of this challenge exercise users will understand how to query and deploy virtual machines using the Azure Linux CLI.

## Process

1. View all resource groups in your current subscription

    * az group list

2. View the virtual machines currently running in your subscription

    * az vm list -d

3. Query Azure for all virtual machines published by "SUSE" which can be deployed

    * az vm image list --publisher SUSE --all

4. Query Azure for all virtual machines published by "Red Hat" that have an LVM partitioning schema

    * az vm image list --publisher RedHat --all |grep -i lvm

5. Query Azure for all virtual machines published by "CentOS" which can be deployed 

    * az vm image list --publisher CentOS --all

6. Provision a new CentOS 7.4 virtual machine using the latest non-LVM-based image

    * az vm create --resource-group ansible-demo-2017 --name ansible-demo --image OpenLogic:CentOS-LVM:7-LVM:7.3.20170816 --public-ip-address-dns-name ansible-demo --authentication-type password --storage-sku Standard_LRS --size Basic_A0 --admin-username demouser --admin-password Ansible1234% 
