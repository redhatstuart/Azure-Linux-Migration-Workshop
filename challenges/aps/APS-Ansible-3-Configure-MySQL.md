# Configure MySQL using Ansible Roles and Playbooks

## Expected Outcome

This challenge will make use of one of the virtual machines created during the previous challenge. Using the roles function of Ansible, and to support the <strong>"Mattermost"</strong> application, deploy MySQL on the database virtual machine.

## Process

1. <strong>Edit the Ansible Hosts file</strong>

    * Determine the IP addresses of the newly running virtual machines ```az vm list -d```
    * Edit the /etc/ansible/hosts file and create the groups [dbservers] and [webservers] if they do not already exist
    * Create one entry in each of the the [dbservers] and [webservers] groups with the fully qualified domain name of each of your two servers
    * Be sure to specify the connection type and the name of the user which you specified in the ```username``` variable in the previous challenge

Each entry should look similar to:

```[webservers]
skirk1975-mm-app.eastus2.cloudapp.azure.com     ansible_connection=ssh        ansible_user=ansibleadmin```

```[dbservers]
skirk1975-mm-db.eastus2.cloudapp.azure.com     ansible_connection=ssh        ansible_user=ansibleadmin```





2. <strong>Download the MySQL role tarball</strong>

    * In the ansible user's home directory, download and untar the following file:  ```wget https://github.com/stuartatmicrosoft/Azure-Linux-Migration-Workshop/raw/master/challenges/aps/roles.tar.gz```

3. <strong>Download the MySQL deployment playbook</strong>

    * Download the MySQL playbook to the ansible user's "repo" directory:  ```https://raw.githubusercontent.com/stuartatmicrosoft/Azure-Linux-Migration-Workshop/master/challenges/aps/mysql.yml```


4. <strong>Execute the playbook</strong>


