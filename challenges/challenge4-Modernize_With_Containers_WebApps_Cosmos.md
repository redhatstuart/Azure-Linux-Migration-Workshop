# Modernize Your Migrated VM using Azure Web Apps, Azure Container Registry, Azure CosmosDB and Docker

## Expected Outcome

This challenge provides a path to modernize the application running on the virtual machine which was migrated in Challenge 3.

Inside the virtual machine, there is a NodeJS application running and exposed on port 8080. It connects to a locally running instance of MongoDB to store its information.

As part of this challenge, we will take the front-end NodeJS application and containerize it using Docker; We will then upload the container to Azure Container Registry.  For the back-end database, we will export the MongoDB data which ahs been entered into the NodeJS WebUI and import it into Azure CosmosDB.

At the end of the challenge, you should have the front-end NodeJS application running as a container inside Azure Web Apps, and the back-end database running in CosmosDB thus removing the need for the virtual machine to exist. This modernization effort is a valid next step in cloud transformation and adoption as workloads are abstracted and migrated to PaaS offerings which are natively available.

## Process

1. <strong>x</strong>

<hr>

