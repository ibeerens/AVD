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
    
    # Install Troubleshoot tools
        Invoke-Command -Session $sessionid -ScriptBlock {
        ($url = 'https://aka.ms/MSRD-Collect'),
        ($zip = 'c:\install\MSRDcollect\MSRD-Collect.zip'),
        ($ziploc = 'c:\install\MSRDcollect'),
        (New-Item -Path 'c:\' -Name 'Install\MSRDcollect' -ItemType 'directory' | Out-Null),
        (Invoke-WebRequest -Uri $url -OutFile $zip),
        (Expand-Archive $zip -DestinationPath $ziploc -Verbose -Force),
        (dir $ziploc -Recurse | Unblock-File)
        }
}
