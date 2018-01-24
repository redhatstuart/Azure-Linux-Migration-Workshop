# Introduction to Azure Container Service (ACS)

## Expected Outcome

This challenge will showcase Azure Container Service

## Process

1. <strong> Create a Kubernetes cluster with ACS </strong>

    * az acs create --orchestrator-type kubernetes --resource-group <YOUR_RG> --name myK8SCluster --generate-ssh-keys --service-principal <APPLICATION_ID> --client-secret <APPLICATION_SECRET_KEY>
    * az acs kubernetes install-cli 

2. <strong> View your ACS cluster and connect it to Kubernetes </strong>

    * az acs list
    ![az acs list](./images/acs-list.png)

3. <strong> View your cluster with Kubernetes </strong>

    * kubectl get nodes

    The error message you receive occurs because the Kubernetes crendetials that ACS has generated have not been downloaded to your active user account. Delete your existing ".kube" directory (if it exists) and then query the Azure CLI for the credentials required to access your cluster.

    * rm -rf $HOME/.kube
    * az acs kubernetes get-credentials -n myk8SCluster -g <YOUR_RG>
    ![az acs kubernetes get-credentials](./images/az-getcred.png)
   
    Note that there now exists a ".kube" directory with the required "config" file in your home directory.

4. <strong> Re-try viewing your cluster with Kubernetes </strong>

    * kubectl get nodes (You are now managing your ACS cluster using the stock Kubernetes manager)
    ![kubectl get nodes](./images/k8sgetnodes.png)

