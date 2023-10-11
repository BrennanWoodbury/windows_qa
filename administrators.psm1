Import-Module .\config.psm1

function adminGroup {
    '--------' | Out-File -FilePath $logFile -Append
    'GroupMembership' | Out-File -FilePath $logFile -Append
    & net localgroup Administrators | Out-File -FilePath $logFile -Append
    '--------' | Out-File -FilePath $logFile -Append
}   