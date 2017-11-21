# Intro to Azure CLI

## Expected outcome

In this lab, you will prepare your workstation VM for using the Azure CLI, sign in, and utilize the Azure CLI to deploy basic Azure resources. You will need to have an RDP client on your local PC and access to the web to launch our Hackfest Workstation VM.

## How to 

1. Using your browser go to the Registration Site listed in your classroom.
    * Please make sure you use a valid work email as it will not allow for commercial e-mail domains.
        * ![SignUp](./images/signup.png)
    * Once you select submit, **DO NOT CLOSE THE BROWSER**.
    * On the Lab and Overview page, navigate to the Lab tab and then select Launch Lab
        * ![Launch Lab](./images/launch2.png)
    * The Lab will begin to deploy. **DO NOT CLOSE THE BROWSER**. This will take some time but the needed credentials will be presented on the page when the provisioning is complete.
        * ![Preparing Lab](./images/preparing.png)
    * Your credentials will be emails to your signup email address as well as presented on the screen
        * ![Credentials](./images/creds-email.png)

2. Launch your RDP client of choice and enter the url of the jump-box provided for you. Use the AdminUsername and AdminPassword provided in your email
    *  ![Jumpbox Credentials](./images/jumpboxinfo.png)
    * It may take a minute or so at first launch to get the desktop to present. This is normal at first log in.

3. Install Azure CLI (AZ CLI) on your workstation
    * Azure CLI is available for Mac, Windows and Linux.
    * You can find installation instructions here: [Install Azure CLI](http://aka.ms/azure-cli-2 
)

4. Log in to your student Azure account via the CLI
    * Use ``az login`` to login to your lab Azure Account. You will be asked to visit ``https://aka.ms/devicelogin`` and use the provided code to authenticate. Use the credentials provided in your e-mail/Lab Provisioning page.
        *    ![Azure Credentials](./images/azureinfo.png)
    * The password is a onetime password and must be changed at first signing in.
    * Your terminal windows will update with a JSON output of your subscription confirming the login has worked.

5. Create a new Azure Resource Group using the AZ CLI
    * You already have a resource group in your subscription. Create the new resource group using the same location as your existing resource group.
    * Name the resource group "MyRG_" followed by your initials

6. Configure Azure CLI Defaults
    * Configure AZ CLI to default to table output
    * Configure AZ CLI to use the same default location as your resource groups

7. Log into interactive mode and create a new Azure storage account using the AZ CLI
    * Make the storage account use Standard Locally Rundandant Storage
    * Create the storage account in the resource group you previously created
    * Create a blob container within this storage account

8. Verify you have now created the resource group and storage account in the portal
    * If not done so already, visit ``https://portal.azure.com``
    


## Advanced areas to explore

1. If you have time, explore using the Azure Cloud Shell [Azure Portal](https://portal.azure.com). 
2. Try creating your own Azure virtual network using the Azure CLI Cloud Shell
