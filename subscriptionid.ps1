# To get the Subscription ID for the remote subscription. We will get the ids of these three subscriptions: IPC-Core, SiteCore non Production by the same order
$HubSubscriptionId= (Get-AzSubscription -SubscriptionName "$(HubSubscriptionName)").ID
echo "##vso[task.setvariable variable=HubSubscriptionIdFromTask;]$HubSubscriptionId"


$SpokeSubscriptionId= (Get-AzSubscription -SubscriptionName "$(SpokeSubscriptionName)").ID
echo "##vso[task.setvariable variable=SpokeSubscriptionIdFromTask;]$SpokeSubscriptionId"
