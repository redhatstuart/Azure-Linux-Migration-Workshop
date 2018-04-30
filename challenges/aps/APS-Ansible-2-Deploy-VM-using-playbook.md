# Deploying Azure Virtual Machines using Ansible Playbooks

## Expected Outcome

This challenge will deploy two Azure virtual machines using native playbook directives.  Unlike the previous challenge, this exercise will not call an external ARM template and will require you to configure the virtual machine parameters as part of the playbook itself.  Due to available time, a template will be provided for you. These virtual machines will be used to host/deploy the communication application <strong>Mattermost</strong>.

## Process

1. <strong>Obtain the VM template</strong>

    * Using the Ansible user you created in the previous challenge, download the provided playbook template: ```wget https://raw.githubusercontent.com/stuartatmicrosoft/Azure-Linux-Migration-Workshop/master/challenges/aps/mm-vm-deploy.yml```

2. <strong>Customize the playbook</strong>

In many of the playbooks being used, variable names will need to be substitued from default values to unique values so as not to overlap and create duplicate host names / DNS names within Azure.  In many cases, you will see references to "firstinitiallastnamebirthyear" in the playbooks we will be using.  This should be substituted with the first initial of your first name, your last name, and your year of birth.  For example, "Stuart Kirk born in 1975" would be "skirk1975".  Edit and customize the following variables in the playbook:

    * appserver
    * appserverdns
    * azuredc (The name of your Azure data center - eastus, centralus, etc)
    * dbserver
    * dbserverdns
    * username (The name of the SSH user which you created in the previous challenge)
    * rgname (The name of the resource group you have been assigned)

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

