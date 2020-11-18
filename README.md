# vnet-peering
vnet peering between vnets in different subscriptions using ARM template through Azure Devops
The process:

- Create a service principal for the project.
- create RBAC (IAM) custom role on the subscription or the resource group, look at the file "service principal access.json" for the access is needed.
- assign the custom role to the service principal under the resource groups of the hub and the spoke vnets. (you don't need to assign it on the subscription level, the least access the best).
- create a project on azure devops
- create two service connections, one for each subscription.
- push the files to azure devops repo of your project
- create a release pipeline (use empty job for now)
- add artifact: use your azure repo
- create a stage:
- three steps will be created:
1- Azure powershell:
    - This task to get the two subscription IDs. we will use these IDs later in the ARM templates 
    - both inline(copy and past the content) or script path could be used to use the file "subscriptionid.ps1"(i used inline script)
    - in order to not hardcode the subscription names in the script you can use variables within the project that in case of we use inline script
2- ARM template deployment: this step for the hub side
    - Deployment Scope: Resource Group
    - select the service connection was created for the hub subscription
    - select the correct subscription, resource group and location.
    - select the template and the parameters file
    - we will need to override the subscription id inside the ARM template with the output of the first step by doing adding this line in the "Override template parameters" section "-RemoteSubscriptionId $(SpokeSubscriptionIdFromTask)"
3- ARM template deployment: this step for the spoke side 
    - Deployment Scope: Resource Group
    - select the service connection was created for the spoke subscription
    - select the correct subscription, resource group and location.
    - select the template and the parameters file
    - we will need to override the subscription id inside the ARM template with the output of the first step by doing adding this line in the "Override template parameters" section "-RemoteSubscriptionId $(HubsubscriptionIdFromTask)"
- create a release then deploy


ARM template notes::

- Vnet-peering is a two steps when it is done using ARM template. you will need to have two ARM templates one for each vnet/subscription. 
- To get the location you can hard code it or use this  
"location": "[resourceGroup().location]"
using this method will look at the resource group of the vnet and get the location of it
- in the name you have to use the name of the vnets and use the "/", otherwise you will receive an error
- the id should look be a representation of this:
"id": "/subscriptions/<subscription ID>/resourceGroups/PeeringTest/providers/Microsoft.Network/virtualNetworks/myVnetB"
- if your hub vnet is connected to a vpn or express route and you want the spoke vnet - to use it then these ARM templates sections are needed
at the Spoke:
"useRemoteGateways": true,
at the Hub:
"allowGatewayTransit": true

look here for more details:
https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2019-11-01/virtualnetworks/virtualnetworkpeerings