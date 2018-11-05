# Provisioning Linux resources in Azure using the Azure CLI

## Expected Outcome

This challenge will serve as an extension to Challenge 1.  As part of this challenge exercise users will understand how to query and deploy virtual machines using the Azure Linux CLI as well as perform basic configuration changes to existing virtual machines.

## Process

1. <strong>View all resource groups in your current subscription</strong>

    * az group list

2. <strong>View the virtual machines currently running in your subscription</strong>

    * az vm list -d

3. <strong>Query Azure for all virtual machines published by "SUSE" which can be deployed</strong>

    * az vm image list --publisher SUSE --all

4. <strong>Query Azure for all virtual machines published by "Red Hat" that have an LVM partitioning schema</strong>

    * az vm image list --publisher RedHat --all |grep -i lvm

5. <strong>Query Azure for all virtual machines published by "OpenLogic" which can be deployed </strong>

    * az vm image list --publisher OpenLogic --all

6. <strong>Determine the variables required to provision a new CentOS 7.5 virtual machine using the latest non-LVM-based image</strong>

    * YOUR_RG_NAME = The name of the resource group you have been assigned
    * YOUR_VM_NAME = The name of your virtual machine - Use any name you wish
    * USERNAME = The name of the user that should be created and given root "sudo" permission when the host is created

7. <strong>Build the VM (You will be prompted for a password to use)</strong>

    * az vm create --resource-group YOUR_RG_NAME --name YOUR_VM_NAME --image OpenLogic:CentOS-LVM:7-LVM:7.5.20180823 --authentication-type password --storage-sku Standard_LRS --size Basic_A0 --admin-username USERNAME

8. <strong>Verify connectivity to the new virtual machine</strong>

    * SSH to the new virtual machine IP address; Login using the username and password credentials you specified in the previous step
    * Determine the quantity and type of CPUs assigned to your host (Make note of this!)
    * Determine the amount of memory assigned to your host (Make note of this!)
    * View all of the disk that has been presented to this host (Make note of this!)

9. <strong>Modify the new virtual machine</strong>

    * Exit the SSH session to the new virtual machine returning back to the "liftshift-source-vm" host
    * Determine the public IP address of the new virtual machine
    * Attach a 5GB external disk to the new virtual machine
    * Determine the name of the public IP address resource assigned to the new virtual machine
    * Configure a FQDN on the public IP address of the new virtual machine -- use the format "firstname-lastname-azure"
    * Verify the FQDN has been configured on the new virtual machine's IP address resource

10. <strong>Re-size the virtual machine</strong>

    * Determine the available resize options for the virtual machine
    * Resize the new virtual machine to a Basic_A2 size

11. <strong>Verify your changes</strong>

    * SSH to the new virtual machine using the new FQDN; Login using the username and password credentials you specified earlier
    * Verify that the additional 5GB disk is attached and is visible as /dev/sdc
    * Verify the new CPU core count of the virtual machine and compare to the output of step 8
    * Verify the new memory capacity of the virtual machine and compare to the output of step 8

Helpful Links:

* [Azure CLI documentation](https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest)
* [Azure CLI Network Docs](https://docs.microsoft.com/en-us/cli/azure/network/public-ip?view=azure-cli-latest)
* [Azure CLI VM Docs](https://docs.microsoft.com/en-us/cli/azure/vm?view=azure-cli-latest)
