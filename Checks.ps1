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

# Reboot
Invoke-Command -Session $sessionid -ScriptBlock {
  (sleep 10),
  (Restart-Computer -Force)
}
  
Invoke-Command -Session $sessionid -ScriptBlock {
  (C:\"Program Files (x86)\F-Secure\PSB\\fs_oneclient_logout.exe" --keycode )
}

# Set Page File
Invoke-Command -Session $sessionid -ScriptBlock {
    ($pagefile = Get-WmiObject Win32_ComputerSystem -EnableAllPrivileges),
    ($pagefile.AutomaticManagedPagefile = $false),
    ($pagefile.put() | Out-Null),
    ($pagefileset = Get-WmiObject Win32_pagefilesetting),
    ($pagefileset.InitialSize = 4991),
    ($pagefileset.MaximumSize = 32768),
    ($pagefileset.Put() | Out-Null),
    (Gwmi win32_Pagefilesetting | Select Name, InitialSize, MaximumSize)
}
