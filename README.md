# Azure Function with Private Endpoint
    + Deploy the Azure Function(Private Endpoint) with GitHub Actions

## Prerequisites
    + Create client id, client secert, subscription and tenant id
    ```
    az ad sp create-for-rbac --name "github-deployment" --role contributor /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP> --sdk-auth
    ```

    + Add Azure client id, client secert, subscription and tenant id into Secret