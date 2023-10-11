Import-Module .\config.psm1

function hardwareConfig {
    $cpuInfo = Get-WmiObject -Class Win32_Processor
    $ramInfo = Get-WmiObject -Class Win32_ComputerSystem
    $ramInGb = $([math]::Round($ramInfo.TotalPhysicalMemory / 1GB, 2))

    # CPU info
    '--------' | Out-File -FilePath $logFile -Append
    'CPU Config' | Out-File -FilePath $logFile -Append
    & $cpuInfo | Out-File -FilePath $logFile -Append
    '********' | Out-File -FilePath $logFile -Append
    # RAM info 
    'RAM Config' | Out-File -FilePath $logFile -Append
    & $ramInfo | Out-File -FilePath $logFile -Append
    "RAM in GB: $ramInGb GB" | Out-File -FilePath $logFile -Append
    '--------' | Out-File -FilePath $logFile -Append
}