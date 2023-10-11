Import-Module .\config.psm1

function ipConfig {
    '--------' | Out-File -FilePath $logFile -Append
    'Network Config' | Out-File -FilePath $logFile -Append
    & Get-NetIPConfiguration -All | Out-File -FilePath $logFile -Append
    '--------' | Out-File -FilePath $logFile -Append
}
