# Variables
$resourcegroup = ''
$hostpool = ''
$location = 'westeurope'

#######################################################################################
### Config
#######################################################################################
$avdvms = 'vmp*'

$sessionhosts = Get-AzWvdSessionHost -ResourceGroupName $resourcegroup -HostPoolName $hostpool | Where-Object {($_.Status -eq 'Available')}

# Get Status
# List PowerState
Get-azvm -Name $avdvms -Status | Select Name,PowerState

# Software confguration
$myCol = @() # Create empty array
ForEach ($sessionhost in $sessionhosts) {
    $session = $sessionhost.Name -replace '^[^:]+/'
    Write-host $session -ForegroundColor Green
    $sessionid = New-Pssession $session
    Invoke-Command -Session $sessionid -ScriptBlock {gpupdate /force}
  
}
