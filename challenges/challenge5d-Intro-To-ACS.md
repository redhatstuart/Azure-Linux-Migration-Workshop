# Introduction to Azure Container Service (ACS)

## Expected Outcome

This challenge will showcase Azure Container Service

## Process

1. <strong> Create a Kubernetes cluster with ACS </strong>

    * az acs create --orchestrator-type kubernetes --resource-group <YOUR_RG> --name myK8SCluster --generate-ssh-keys --service-principal <appID> --client-secret <Application Secret Key>
    * az acs kubernetes install-cli 
    * az acs kubernetes get-credentials --resource-group myResourceGroup --name myK8SCluster

2. <strong> View your ACS cluster and connect it to Kubernetes </strong>

    * az acs list
    * az acs kubernetes get-credentials -n myk8SCluster -g <YOUR_RG>

3. <strong> View your cluster with Kubernetes </strong>

    * kubectl get nodes
