# Performing a Linux migration to Azure with CloudEndure

## Expected Outcome

This challenge will give you practical experience migrating a running host to Microsoft Azure. While this virtual machine is technically already running in Azure, it is running in a nested virtualization configuration on your host.

Inside the CentOS Linux host that you are using as your desktop, there is a running virtual machine entitled "migrate-host".  It, too, is a CentOS virtual machine running under the KVM hypervisor. Microsoft has partnered with CloudEndure to provide access to their migration toolset to showcase its capabilities and give you hands-on experience with the migration process.  At the end of the challenge, you should have a new virtual machine created in Microsoft Azure which you can SSH to and verify that it is, indeed, the same host.

The source host to be migrated can be an on-premise physical host, a virtual machine on any popular hypervisor (VMWare, KVM, etc), or it may also exist in another public cloud. CloudEndure is agnostic to the source environment and performs a block-level copy of the host into your Azure subscription as part of the replication process.

## Process

1. <strong>Register for a CloudEndure account</strong>
    * Visit & fill out the registration page located on the white-board at the front of the classroom.
    * Check the account for the e-mail address which you entered, and open the email from "Jonathan Bloom" at CloudEndure regarding "Confirm your CloudEndure account request"
    * Click on the link in the e-mail to "complete this form"

      ![Register For CE Account](./images/ceconfirm.jpg)

<hr>

2. <strong>Log in to the CloudEndure Console</strong>
    * Login:  http://www.cloudendure.com

<hr>

3. <strong>Set Up CloudEndure</strong>

   * You will be presented with a dashboard which will allow you to select the type of project you wish you control.

     ![CloudEndure Dashboard](./images/celogin-1.jpg)

   * <strong>Select "Default Migration Project"</strong>

      ![CloudEndure Select Project](./images/celogin-2.jpg)

   * <strong>You will then receive an alert message indicating that the CloudEndure console has not yet been configured. You may safely click "Continue" as we will configure the console in the next step.</strong>

      ![CloudEndure Dismiss Alert](./images/celogin-3.jpg)

<hr>

4. <strong>Populate Service Principal Information to CloudEndure console</strong>

    * You must now configure CloudEndure to connect to Microsoft Azure. A service principal has been created for you as part of this challenge exercise and will allow CloudEndure to connect to your subscription.

      ![SP Information Screen](./images/sp-information.jpg)

    * Populate the service principal information into the CloudEndure console; Navigate to the "Setup & Info" tab in CloudEndure and then choose the "ARM Credentials" tab.

      ![Populate Blank Service Principal](./images/sp-setup.jpg)

    * Based on the data in this example, the completed page would appear as follows:

      ![Populated Service Principal](./images/sp-populated.jpg)

<hr>

5. <strong>Define the target Replication Settings and specify an Azure Data Center location</strong>

    * After the Service Principal information is entered and saved, you will need to select the target Azure Data Center location for your CloudEndure migration project. Select the "Live Migration Target" drop-down and choose the Azure Data Center "Azure ARM East US 2", "Azure ARM Central US", or "Azure ARM West US 2".

      ![Populate Blank Replication Settings](./images/cerepsettings-1.jpg)

    * In this case, "East US 2" was chosen. After the Azure Data Center is chosen, you may specify which existing virtual network you would like the migrated hosts to be connected to.  In this case, the populated value of <strong>Default</strong> can remain.

      ![Populated Replication Settings](./images/cerepsettings-2.jpg)

    * After the information is saved, you are now ready to configure your host for migration. Click on "Show Me How"

      ![Completed Replication Settings](./images/cerepsettings-3.jpg)

<hr>

6. <strong>Verify SSH access to the migrate-host virtual machine and prepare it for migration to Microsoft Azure</strong>

    * Determine the IP address of the migrate-host virtual machine. This should be contained in a text file on your CentOS desktop
    * SSH to the migrate-host virtual machine using the IP address and credentials provided

      ![SSH to migrate-host VM](./images/prephost-1.jpg)

    * Determine if the required Hyper-V drivers are already installed on the migrate-host virtual machine

      ![Check for HV Drivers](./images/prephost-2.jpg)

    * Edit the /etc/dracut.conf file and force-add the Hyper-V drivers required for operation within Microsoft Azure. These were not added at the time this host was built since, according to what it could detect, it is running solely inside a KVM hypervisor and as such the Hyper-V drivers are not required. 

      ![Edit Dracut](./images/prephost-3.jpg)

    * Re-make the initramfs of the migrate-host

      ![Remake Initramfs](./images/prephost-4.jpg)

    * Verify that the Hyper-V drivers are now installed on the migrate-host virtual machine

      ![Check for HV Drivers](./images/prephost-5.jpg)

<hr>

7. <strong>Deploy the CloudEndure Migration Agent onto the migrate-host virtual machine</strong>

    * Navigate to the "Machines" tab. The required commands to execute are present on this screen; You will be downloading and installing the CloudEndure migration agent.

      ![Install CE Agent](./images/ceagentinstall-1.jpg) 

    * Download the CloudEndure Migration Agent

      ![Download CE Agent](./images/cetestmigrate-1.jpg) 

    * Install the CloudEndure Migration Agent -- hit "Enter" when asked for which disks to replicate

      ![Install CE Agent](./images/cetestmigrate-2.jpg)

    * View the environment setup in the CloudEndure console

      ![Setup CE Environment](./images/ceagentinstall-2.jpg)

    * After the CloudEndure environment is setup, an initial sync will occur

      ![Initial Sync 1](./images/ceagentinstall-3.jpg)

      ![Initial Sync 2](./images/ceagentinstall-4.jpg)

<hr>

8. <strong>Execute a test migration</strong>

    * On the "Setup & Info" tab, wait for the initial sync to be completed from Step 7

      ![Verify Sync Complete](./images/ceagentinstall-5.jpg)

    * After the initial sync is complete, return to the "Machine" tab and confirm that the migrate-host is indeed ready to be tested

      ![Verify Ready for Testing](./images/ceagentinstall-6.jpg)

    * Select the checkbox next to the "migrate-host" virtual machine, Click "Launch Target Machines" and select "Test"

    * After the test is completed, this should reflect in the "Machines" tab

      ![Verify Test Complete](./images/ceagentinstall-7.jpg)

<hr>

9. <strong>Verify connectivity to the migrated virtual machine</strong>

    * Determine the IP address of the migrated virtual machine; Double-click on "migrate-host" and explore the newly created "Target" tab

      ![Verify Test Complete](./images/ceagentinstall-8.jpg)

    * SSH to the virtual machine at the IP address provided by CloudEndure; This is your new IP address in Microsoft Azure.

      ![Verify SSH Connectivity](./images/ceagentinstall-9.jpg)

<hr>

10. <strong>Perform a migration cut-over</strong>

    * As a final step, return back to the "Machines" tab and perform a formal cutover of the migrate-host virtual machine
    * Select the checkbox next to the "migrate-host" virtual machine, Click "Launch Target Machines" and select "Cutover"

      ![Perform Cutover](./images/ceagentinstall-10.jpg)

    * After the cutover is completed, this should reflect in the "Machines" tab

      ![Verify Cutover Complete](./images/ceagentinstall-11.jpg)

    * Determine the new IP address of the migrated virtual machine; Double-click on "migrate-host" and explore the "Target" tab; Note that the IP address has changed

      ![Verify New IP](./images/ceagentinstall-12.jpg)

    * SSH to the virtual machine at the IP address provided by CloudEndure; This is your new IP address in Microsoft Azure.

      ![Verify SSH Connectivity](./images/ceagentinstall-13.jpg)

