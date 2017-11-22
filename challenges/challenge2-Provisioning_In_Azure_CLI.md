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

5. Query Azure for all virtual machines published by "OpenLogic" which can be deployed 

    * az vm image list --publisher OpenLogic --all

6. Provision a new CentOS 7.4 virtual machine using the latest non-LVM-based image

    * YOUR_RG_NAME = The name of the resource group you have been assigned
    * YOUR_VM_NAME = The name of your virtual machine - Use any name you wish
    * USERNAME = The name of the user that should be created and given root "sudo" permission when the host is created

<strong>Build the VM (You will be prompted for a password to use)</strong>

    * az vm create --resource-group YOUR_RG_NAME --name YOUR_VM_NAME --image OpenLogic:CentOS:7.4:7.4.20171110 --authentication-type password --storage-sku Standard_LRS --size Basic_A0 --admin-username USERNAME

7. Verify connectivity to the new virtual machine

    * SSH to the new virtual machine IP address; Login using the username and password credentials you specified in the previous step
    * Determine the quantity and type of CPUs assigned to your host
    * Determine the amount of memory assigned to your host
    * View all of the disk that has been presented to this host

8. Modify the new virtual machine

    * Exit the SSH session to the new virtual machine returning back to the "liftshift-source-vm" host
    * Determine the public IP address of the new virtual machine
    * Attach a 5GB external disk to the new virtual machine
    * Determine the name of the public IP address resource assigned to the new virtual machine
    * Configure a FQDN on the public IP address of the new virtual machine -- use the format "firstname-lastname-azure"

9. Verify your changes

    * SSH to the new virtual machine using the new FQDN; Login using the username and password credentials you specified earlier
    * Verify that the additional 5GB disk is attached and is visible as /dev/sdc


