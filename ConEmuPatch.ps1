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

Write-Host "Installing useful Visual Studio Code extensions"
&code --install-extension ajhyndman.jslint
&code --install-extension alefragnani.Bookmarks
&code --install-extension bibhasdn.unique-lines
&code --install-extension DotJoshJohnson.xml
&code --install-extension eamodio.gitlens
&code --install-extension eriklynd.json-tools
&code --install-extension jebbs.plantuml
&code --install-extension Leopotam.csharpfixformat
&code --install-extension marp-team.marp-vscode
&code --install-extension mauve.terraform
&code --install-extension mblode.pretty-formatter
&code --install-extension mindginative.terraform-snippets
&code --install-extension ms-azuretools.vscode-docker
&code --install-extension ms-vscode-remote.remote-wsl
&code --install-extension ms-vscode.csharp
&code --install-extension ms-vscode.powershell
&code --install-extension slevesque.vscode-hexdump
&code --install-extension tht13.html-preview-vscode
&code --install-extension Tyriar.sort-lines
&code --install-extension yuichinukiyama.TabSpacer
Write-Host "Done"

