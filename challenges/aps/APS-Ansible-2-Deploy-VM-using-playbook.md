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
    * YOUR_SSH_PUBLIC_KEY (This needs to be inserted twice, once for each VM which is being created)

3. <strong>Execute the playbook</strong>

    * Run the playbook and deploy the virtual machine infrastructure ```ansible-playbook mm-vm-deploy.yml```

