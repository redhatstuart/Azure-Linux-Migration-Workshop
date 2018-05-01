# Install the Mattermost Application

## Expected Outcome

This challenge will make use of Ansible Playbooks to download and install the Mattermost application onto the webserver which was deployed in the second Ansible challenge.

## Process

1. <strong>Download the playbook template</strong>

    * Download the playbook template to the ansible user's home directory: ```wget https://raw.githubusercontent.com/stuartatmicrosoft/Azure-Linux-Migration-Workshop/master/challenges/aps/mmost.yml```

2. <strong>Configure database server</strong>

    * Edit the template to configure the database server in the playbook.
    * Look for the play "Configure Mattermost Data Source"
    * Edit the data source to reflect the name of your database server
    * The only content which should be changed is ```firstinitiallastnamebirthyear-mm-db.YOUR_DC.cloudapp.azure.com```.  You will insert the name of your database server here, ex:
    * ```skirk1975-mm-db.eastus2.cloudapp.azure.com```

3. <strong>Execute the playbook</strong>

    * ```ansible-playbook mmost.yml```
