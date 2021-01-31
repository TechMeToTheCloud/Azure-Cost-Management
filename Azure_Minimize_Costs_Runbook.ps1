Import-Module Az.Accounts
Import-Module Az.Resources
Import-Module Az.Synapse
Import-Module Az.StreamAnalytics

$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "

    $servicePrincipalConnection = Get-AutomationConnection -Name $connectionName

    "Logging in to Azure..."
    $connectionResult =  Connect-AzAccount -Tenant $servicePrincipalConnection.TenantID `
                             -ApplicationId $servicePrincipalConnection.ApplicationID   `
                             -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint `
                             -ServicePrincipal
    "Logged in."

}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}


function minimizeSynapseSQLPool($resource){
    $pool = Get-AzSynapseSqlPool -ResourceId $resource.resourceId
        if($pool.Status -eq "online"){
            $msg = "(Azure Synapse SQL Pool) Pool "+$resource.name+" is running and will be paused"
            Write-Output $msg    
            Suspend-AzSynapseSqlPool -ResourceId $resource.ResourceId
        }
}

function minimizeAsa($params){
    $asa = Get-AzStreamAnalyticsJob -ResourceGroupName $params[0] -Name $params[1]
        if($asa.JobState -eq "Running"){
            $msg = "(Azure Stream Analytics Job) Job "+$params[1]+" is running and will be stopped"
            Write-Output $msg
            Stop-AzStreamAnalyticsJob -ResourceGroupName $params[0]  -Name $params[1]
        }
}

$resourceGroups = Get-AzResourceGroup

foreach($currentResourceGroup in $resourceGroups){
    $groupName = $currentResourceGroup.ResourceGroupName
    #Write-Output "Resource Group: "$groupName
    $resources = Get-AzResource -ResourceGroupName $groupName
    foreach($resource in $resources){
        #Synapse Pool Case
        if($resource.ResourceType -eq "Microsoft.Synapse/workspaces/sqlPools"){
            minimizeSynapseSQLPool($resource)
        }
        #Azure Streaming Job Case
        if($resource.ResourceType -eq "Microsoft.StreamAnalytics/streamingjobs"){
            minimizeAsa($groupName,$resource.Name)
        }
    }
}     