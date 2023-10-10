$logFile = "logs.log"

function ipConfig {
    '--------' | Out-File -FilePath $logFile -Append
    'Network Config' | Out-File -FilePath $logFile -Append
    & Get-NetIPConfiguration -All | Out-File -FilePath $logFile -Append
    '--------' | Out-File -FilePath $logFile -Append
}