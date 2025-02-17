using namespace System.Net

# Input bindings are passed in via param block.
param($request, $TriggerMetadata)

#Set default value
$status = 200

Try{
    # Write to the Azure Functions log stream.
    Write-Output "PowerShell HTTP trigger function processed a request."

    # Interact with query parameters or the body of the request.
    Write-Output ($request | ConvertTo-Json -depth 99)

    $ResourceGroupName = $env:RG4
    $VMName = $env:VM4
    $Context = $env:Context
    $Action = $request.query.Action

    $null = Connect-AzAccount -Identity
    $null = Set-AzContext $Context

    $vmStatus = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName -Status
    Write-output $vmStatus
    If(-not ($vmStatus)){
        $status = 404
        Throw "ERROR! VM [$VMName] not found. Please check if the 'Subscription ID', 'Resource Group Name' or 'VM name' is correct and exists."
    }
    [string]$Message = "Virtual machine [$VMName] status: " + $vmStatus.statuses[-1].displayStatus
    Switch($Action){
        'start'{
            If($vmStatus.statuses[-1].displayStatus -ne 'VM running'){
                Start-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName -Verbose
                [string]$message += '... Virtual machine is now starting'
            }
            Else{
                [string]$message += '... Virtual machine is already running'
            }
        }
        'stop'{
            If($vmStatus.statuses[-1].displayStatus -ne 'VM deallocated'){
                Stop-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName -Force -Verbose
                [string]$message += '... Virtual machine is stopping'
            }
            Else{
                [string]$message += '... Virtual machine is already deallocated'
            }
        }
        'status'{
            [string]$message
        }
        default{
            [string]$message += ". $($request.query.action) is outside of the allowed actions. Only allowed actions are: 'start', 'stop', 'status'"
            $status = 400
        }
    }
}
Catch{
    [string]$message += $_
}

Write-output $message

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value (
    [HttpResponseContext]@{
        StatusCode = $status
        body = [string]$message
        headers = @{ "content-type" = "text/plain" }
    }
)
