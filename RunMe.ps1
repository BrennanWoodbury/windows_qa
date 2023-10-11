Import-Module .\config.psm1

function adminGroup {
    '--------' | Out-File -FilePath $logFile -Append
    'GroupMembership' | Out-File -FilePath $logFile -Append
    & net localgroup Administrators | Out-File -FilePath $logFile -Append
    '--------' | Out-File -FilePath $logFile -Append
}   

function services {
    foreach ($name in $serviceNames) {
        if (Get-Service -Name $name -ErrorAction SilentlyContinue) {
            $service = Get-Service -Name $name

            if ($service.Status -eq 'Running') {
                Write-Host "$name is installed and running" | Out-File -FilePath $logFile -Append
            }
            else {
                Write-Host "$name is installed, but is not running" | Out-File -FilePath $logFile -Append
            }
        }
        else {
            Write-Host "$name is not installed" | Out-File -FilePath $logFile -Append
        }
    }
}

function domain {
    '--------' | Out-File -FilePath $logFile -Append
    'Domain Config' | Out-File -FilePath $logFile -Append

    & Get-WmiObject -Class Win32_ComputerSystem | Out-File -FilePath $logFile -Append

    '--------' | Out-File -FilePath $logFile -Append
}

function hardwareConfig {
    $cpuInfo = Get-WmiObject -Class Win32_Processor
    $ramInfo = Get-WmiObject -Class Win32_ComputerSystem
    $ramInGb = $([math]::Round($ramInfo.TotalPhysicalMemory / 1GB, 2))

    # CPU info
    '--------' | Out-File -FilePath $logFile -Append
    'CPU Config' | Out-File -FilePath $logFile -Append
    & Get-WmiObject -Class Win32_Processor | Out-File -FilePath $logFile -Append
    '********' | Out-File -FilePath $logFile -Append
    # RAM info 
    'RAM Config' | Out-File -FilePath $logFile -Append
    & Get-WmiObject -Class Win32_ComputerSystem | Out-File -FilePath $logFile -Append
    "RAM in GB: $ramInGb GB" | Out-File -FilePath $logFile -Append
    '--------' | Out-File -FilePath $logFile -Append
}

function ipConfig {
    '--------' | Out-File -FilePath $logFile -Append
    'Network Config' | Out-File -FilePath $logFile -Append
    & Get-NetIPConfiguration -All | Out-File -FilePath $logFile -Append
    '--------' | Out-File -FilePath $logFile -Append
}

function lastUpdated {
    '--------' | Out-File -FilePath $logFile -Append
    'Update History' | Out-File -FilePath $logFile -Append
    & Get-Hotfix | Sort-Object InstalledOn -Descending | Out-File -FilePath $logFile -Append
    '--------' | Out-File -FilePath $logFile -Append
}


adminGroup
services
domain
hardwareConfig
ipConfig
lastUpdated