$servers = Get-Content -Path "$env:USERPROFILE\Desktop\servers.txt"
$scriptPath = "$env:USERPROFILE\Desktop\qa.ps1"

Invoke-Command -ComputerName $servers -FilePath $scriptPath
