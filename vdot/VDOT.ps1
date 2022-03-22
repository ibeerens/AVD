<#
    .SYNOPSIS
        Virtual Desktop Optimalization Tool (VDOT)
    .DESCRIPTION
        Download the Virtual Desktop Optimalization Tool (VDOT), creates a folder called optimize and runs VDOT 
    .NOTES
        Version:        1.0
        Author:         Ivo Beerens
                        info@ivobeerens.nl
        Creation Date:  13-02-2022
        Plattform:      Windows multi session
        Changelog:      
                        22-02-2022      1.0 - Initial script development
    .COMPONENT

    .LINK
        https://github.com/The-Virtual-Desktop-Team/Virtual-Desktop-Optimization-Tool
        https://docs.microsoft.com/en-us/windows-server/remote/remote-desktop-services/rds-vdi-recommendations-2004
    .Example
#>

# Variables
$verbosePreference = 'Continue'
$vdot = 'https://github.com/The-Virtual-Desktop-Team/Virtual-Desktop-Optimization-Tool/archive/refs/heads/main.zip' 
$vdot_location = 'c:\Optimize' 
$vdot_location_zip = 'c:\Optimize\vdot.zip'

# Enable TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Create Folder
$checkdir = Test-Path -Path $vdot_location
if ($checkdir -eq $false){
    Write-Verbose "Creating '$vdot_location' folder"
    New-Item -Path 'c:\' -Name 'Optimize' -ItemType 'directory' | Out-Null
}
else {
    Write-Verbose "Folder '$vdot_location' already exists."
}

# Download VDOT
Invoke-WebRequest -Uri $vdot -OutFile $vdot_location_zip

# Expand Archive
Expand-Archive $vdot_location_zip -DestinationPath $vdot_location -Verbose -Force

# Remove Archive
Remove-Item $vdot_location_zip

# Unblock all files
dir $vdot_location -Recurse | Unblock-File

# Change folder to VDOT
$vdot_folder = $vdot_location + '\Virtual-Desktop-Optimization-Tool-main' 
cd $vdot_folder

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force
.\Windows_VDOT.ps1 -Verbose -AcceptEULA

# Sleep 5 seconds
sleep 5

# Remove folder
cd \
Remove-Item $vdot_location -Recurse -Force
