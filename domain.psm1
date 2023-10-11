Import-Module .\config.psm1

function domain {
    '--------' | Out-File -FilePath $logFile -Append
    'Domain Config' | Out-File -FilePath $logFile -Append

    & Get-WmiObject -Class Win32_ComputerSystem | Out-File -FilePath $logFile -Append

    '--------' | Out-File -FilePath $logFile -Append
}