# May need to set 
# Set-ExecutionPolicy unrestricted

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) 
{
    Write-Host "Restart Powershell as Admin, and re-run script"
    return
}

Write-Host "Patching ConEmu.xml"
$guid = (Get-ItemProperty -Path Registry::HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Lxss -Name DefaultDistribution ).DefaultDistribution
Write-Host "Patching done"
(Get-Content -path ConEmu.xml -Raw) -replace '{cbeb2bc9-cdc3-40fa-9949-00ffa3e9e39b}', $guid | Set-Content ConEmu.xml
if (-not (Test-Path -Path 'C:\Program Files\ConEmu' -PathType Container)) 
{
    Write-Host "Install ConEmu first, then re-run"
    return
}

Write-Host "Copying to C:\Program Files\ConEmu\ConEmu.xml"
Copy-Item ConEmu.xml -Destination 'C:\Program Files\ConEmu' -Force
Write-Host "Done"

