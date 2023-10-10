Import-Module .\config.psm1

function lastUpdated {
    '--------' | Out-File -FilePath $logFile -Append
    'Update History' | Out-File -FilePath $logFile -Append
    & Get-Hotfix | Sort-Object InstalledOn -Descending | Out-File -FilePath $logFile -Append
    '--------' | Out-File -FilePath $logFile -Append
}