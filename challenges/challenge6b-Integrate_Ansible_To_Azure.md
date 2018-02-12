# Integrating Ansible CLI to Microsoft Azure

## Expected Outcome

This challenge will provide instructions on extending your existing Ansible CLI deployment to Microsoft Azure. At the end of the challenge you should have a newly provisioned virtual machine in Azure created by Ansible.

## Process

1. <strong>Install the following required RPMs on your "liftshift-source-vm" server:</strong>

    * epel-release 

2. <strong>Install the Ansible RPM from EPEL</strong>

3. <strong>Install the required Python modules</strong>

    * Upgrade to the latest version of pip
    * Install the Azure Python SDK Modules (Install using pip)

4. <strong>Create and provision the Ansible user</strong>

    * Create the Ansible user
    * Switch user to become the Ansible user inheriting its properties
    * Generate an SSH keypair for the ansible user
    * Create a directory called "repo" off of the Ansible user's home directory
    * Switch into the "repo" directory
    * Download the playbook template located at: https://raw.githubusercontent.com/stuartatmicrosoft/Azure-Linux-Migration-Workshop/master/provision-scripts/centos-azure-create.yml

5. <strong>Prepare the Ansible playbook</strong>

    Edit the centos-azure-create.yml playbook and replace the following values:

    * YOUR_AZURE_DC   - the name of the Azure Datacenter you are currently using for this lab, for example "eastus"
    * YOUR_RG         - the name of the resource group which your resources have been deployed to thus far
    * YOUR_SSH_PUBKEY - the public SSH key fwhich was generated in Step 3. Be careful not to insert any blank lines when pasting the SSH key

6. <strong>Create and populate the Azure Credentials file</strong>

    * Create a directory called ".azure" off of the Ansible user's home directory
    * Switch into the ".azure" directory
    * Download the credentials file located at: https://raw.githubusercontent.com/stuartatmicrosoft/Azure-Linux-Migration-Workshop/master/provision-scripts/credentials
    * Edit the credentials file and fill in the service principal value information as follows:
        * subscription_id = Subscription Id
        * tenant = Tenant Id
        * client_id = Application Id
        * secret = Application Secret Key

7. <strong>Deploy the virtual machine</strong>

    * Execute the playbook

8. <strong>Test connectivity to the host</strong>

    * Determine the IP address which has been assigned to the host
    * SSH to the new virtual machine with the credential "ansibleadmin" as specified in the playbook; A password should not be necessary.

