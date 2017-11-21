# Intro to Azure Container Service (AKS)

## Expected outcome

In this lab, you will get introduced to the new Azure Container Service (AKS). As you can tell the acronym doesn't match the wording, and that is because AKS is based off of the Kubernetes Orchestrator (the K in AKS). This lab will take you through verifying that your Azure CLI is registered to use the new service, along with having you create a Kubernetes container cluster and create your own yaml manifest file to stand up your first highly-available container application!

## How to 

1. Starting from your workstation terminal screen, use Azure CLI to determine if your susbcription has access to the Microsoft.ContainerService provider (this is what allows you to submit AKS requests).
    * You will need to use the Azure CLI provider command to determine status: ``az provider`` followed by the necessary options.
    
2. Now that you have confirmed that you have access to the AKS provider, go ahead and create your first cluster.
    * Use the ``az aks`` command to create your cluster
    * You only need to provide resource group, name, node count, and what SSH authentication mechanism to use
    * If you get stuck, check out the Azure CLI reference for AKS commands: [AZ CLI Reference](https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest)

3. Connect to your Kubernetes cluster through the terminal
    * Azure CLI comes with built in commands under the ``az aks`` command sets that allow you to install the Kubernetes CLI (kubectl)
    * Azure CLI also allows you to setup the configuration of kubectl to connect to your cluster, checkout the ``az aks get-credentials`` command
    * Once configuration is complete you should be able to run ``kubectl get nodes`` to see a listing of the nodes available in your cluster
    
   



## Advanced areas to explore

1. 
