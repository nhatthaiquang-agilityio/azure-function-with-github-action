# Azure Function with Private Endpoint
    + Create Infrastructure with Terraform
    + Deploy the Azure Function(Private Endpoint) with GitHub Actions

### Features
    + A Function App with a basic .NET HTTP triggered Azure Function.
    + An Azure Virtual Network and Private Endpoint
    + PrivateLink DNZ
    + Service Bus
    + Storage Account
    + Deployment with GitHub Actions

## Prerequisites
### Create client id and client secret with Contributor Role for deployment
    + Create client id, client secret, subscription and tenant id
    ```
    az ad sp create-for-rbac --name "github-deployment" --role contributor /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP> --sdk-auth
    ```

    + Add AZURE_CLIENT_ID, AZURE_CLIENT_SECRET, AZURE_SUBSCRIPTION_ID and AZURE_TENANT_ID into Secret of GitHub Repo(Using Terraform)

    + Add AZURE_CREDENTIALS into Secret of GitHub Repo (using Azure Login)
    ```
    {
        "clientSecret": "",
        "subscriptionId": "",
        "tenantId": "",
        "clientId": ""
    }
    ```

### Create Storage Account in Azure Portal
    + Create a storage account and a container. It will be save terraform state file.
![Terraform State File](./Images/terraform-state-file.png)

### Create GitHub Agent(Self-hosted Runner)
    + Create Azure Virtual Machine(the same virtual network of Azure Function App)
        - Install Azure CLI
        - Install self-hosted runner

![Install Self Hosted Runner](./Images/gh-agent-deployment.png)

### Results
![All Resources](./Images/all-resources.png)
![GitHub Actions Pipeline](./Images/gh-pipeline.png)
![Azure Function App in Virtual Network](./Images/function-app.png)

## Deploy a public Azure Function via GitHub Actions
+ Create a public Azure Function in the Azure Portal
+ Set SCM Basic Authentication
+ Get Publish Profile and add into secret of GitHub repo settings
+ Deployment (az-deployment.yml or azure-deployment.yml)

### Results
![Authen 401](./Images/authen-401.png)

![SCM Authen](./Images/smc-basic-authen.png)

![Publish Profile](./Images/get-publish-profile.png)

![Deployment](./Images/deployment.png)