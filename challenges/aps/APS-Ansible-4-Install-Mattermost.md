# Install the Mattermost Application

## Expected Outcome

This challenge will make use of Ansible Playbooks to download and install the Mattermost application onto the webserver which was deployed in the second Ansible challenge.

## Process

1. <strong>Examine provisioned NICs</strong>

View the list of network interface cards that have been provisioned in your resource group for the Mattermost application and database servers:

    * ``` az network nic list | grep mm ``` 

2. <strong>Examine provisioned NSGs</strong>

View the list of network security groups that have been provisioned in your resource group for the Mattermost application and database servers:

    * ``` az network nsg list | grep mm ```

3. <strong>Modify NICs to reference correct NSGs</strong>

Ensure that the network interface cards are referencing the correct network security group for the two Mattermost servers. 

For the commands below, "YOUR_RG" will be the name of the resource group to which you have been assigned, for example: ODL-LIFTSHIFT-1234.

The variable YOUR_ID is the first-initial-last-name-birth-year reference. For example, Stuart Kirk born in 1975 would be skirk1975, and the NIC and NSG for the application server would be <strong>skirk1975-mm-app-nic</strong> and <strong>skirk1975-mm-app-nsg</strong> respectively.

    * az network nic update -g YOUR_RG -n YOUR_ID-mm-app-nic --network-security-group YOUR_ID-mm-app-nsg
    * az network nic update -g YOUR_RG -n YOUR_ID-mm-db-nic --network-security-group YOUR_ID-mm-db-nsg

4. <strong>Download the playbook template</strong>

    * Download the playbook template to the ansible user's home directory: ```wget https://raw.githubusercontent.com/stuartatmicrosoft/Azure-Linux-Migration-Workshop/master/challenges/aps/mmost.yml```

5. <strong>Configure database server</strong>

    * Edit the template to configure the database server in the playbook.
    * Look for the play "Configure Mattermost Data Source"
    * Edit the data source to reflect the name of your database server
    * The only content which should be changed is ```YOUR_ID-mm-db.YOUR_DC.cloudapp.azure.com```.  You will insert the name of your database server here, ex:
    * ```skirk1975-mm-db.eastus2.cloudapp.azure.com```

6. <strong>Execute the playbook</strong>

    * ```ansible-playbook mmost.yml```
