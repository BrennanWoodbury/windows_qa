$hostname = hostname
$currentDateTime = Get-Date -Format "yyyyMMdd_HHmmss"

$logFile = "$env:USERPROFILE\Desktop\BCS_QA_logs\$hostname-$currentDateTime.log"

$serviceNames = @{
    "Crowdstrike"    = "CSFalconService"
    "Sophos"         = "Sophos"
    "Tripwire"       = "TripwireAxonAgent"
    "Windows Update" = "wuauserv"
    "VMWare tools"   = "VMTools"
    "Nessus"         = "Tenable Nessus Agent"
    "SNMP"           = "SNMP"
    "MSSQL"          = "MSSQLSERVER"
    "BigFix"         = "BESClient"
}


if (-not (Test-Path -Path $logFile -PathType Leaf)) {
    New-Item -Path $filePath -ItemType File -Force

}


"Hostname: $hostname" | Out-File -FilePath "$logFile" -Encoding UTF8 -Append 


function getAdminGroup {
    '--------' | Out-File -FilePath "$logFile" -Encoding UTF8 -Append 
    'GroupMembership' | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
    & net localgroup Administrators | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
    '--------' | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
}   

function getServices {
    '--------' | Out-File -FilePath "$logFile" -Encoding UTF8 -Append 
    'Services Information' | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
    '' | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
    '' | Out-File -FilePath "$logFile" -Encoding UTF8 -Append

    foreach ($key in $serviceNames.Keys) {
        if (Get-Service -Name $serviceNames[$key] -ErrorAction SilentlyContinue) {
            $service = Get-Service -Name $name

            if ($service.Status -eq 'Running') {
                "+ $key is installed and running" | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
            }
            else {
                "- $key is installed, but is NOT running" | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
            }
        }
        else {
            "- $key is NOT installed" | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
        }
    }
    '--------' | Out-File -FilePath "$logFile" -Encoding UTF8 -Append 

}

# function getDomain {
#     '--------' | Out-File -FilePath $logFile -Append
#     'Domain Config' | Out-File -FilePath $logFile -Encoding UTF8 -Append

#     & Get-WmiObject -Class Win32_ComputerSystem | Out-File -FilePath $logFile -Encoding UTF8 -Append

#     '--------' | Out-File -FilePath $logFile -Encoding UTF8 -Append
# }

function getHardwareConfig {
    $cpuInfo = Get-WmiObject -Class Win32_Processor
    $ramInfo = Get-WmiObject -Class Win32_ComputerSystem
    $ramInGb = $([math]::Round($ramInfo.TotalPhysicalMemory / 1GB, 2))
    $cpuCores = $cpuInfo.NumberOfCores
    $drives = Get-WmiObject -Class Win32_LogicalDisk
    $pageFiles = Get-WmiObject -Class Win32_PageFileSetting

    # CPU info
    '--------' | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
    'CPU Config' | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
    & Get-WmiObject -Class Win32_Processor | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
    "CPU Cores: $cpuCores" | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
    '********' | Out-File -FilePath "$logFile" -Encoding UTF8 -Append

    # RAM info 
    'RAM and Domain Config' | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
    & Get-WmiObject -Class Win32_ComputerSystem | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
    "RAM in GB: $ramInGb GB" | Out-File -FilePath "$logFile" -Encoding UTF8 -Append

    # Disk info
    '********' | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
    "Drive Information: " | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
    "" | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
    "" | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
    foreach ($drive in $drives) { 
        $driveLetter = $drive.DeviceID
        $driveSizeGB = [math]::Round($drive.Size / 1GB, 2)
        "Drive: $driveLetter, Size: $driveSizeGB GB" | Out-File -FilePath "$logFile" -Encoding UTF8 -Append  
    }

    # Page File info
    '********' | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
    "Page File Information: " | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
    "" | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
    "" | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
    foreach ($pageFile in $pageFiles) {
        $pageFileLocation = $pageFile.Caption
        $pagefileSizeMB = [math]::Round($pagefile.InitialSize / 1MB, 2)
        $pagefileMaxSizeMB = [math]::Round($pagefile.MaximumSize / 1MB, 2)

        "Pagefile Location: $pagefileLocation" | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
        "Initial Size: $pagefileSizeMB MB" | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
        "Maximum Size: $pagefileMaxSizeMB MB" | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
    }
    '--------' | Out-File -FilePath "$logFile" -Encoding UTF8 -Append

}
function osInformation { 

    $osInfo = Get-WmiObject -Class Win32_OperatingSystem

    $osName = $osInfo.Caption
    $osVersion = $osInfo.Version
    '--------' | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
    'OS Information: ' | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
    '' | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
    '' | Out-File -FilePath "$logFile" -Encoding UTF8 -Append

    "Operating System: $osName" | Out-File -FilePath "$logFile" -Encoding UTF8 -Append 
    "Version: $osVersion" | Out-File -FilePath "$logFile" -Encoding UTF8 -Append 
    '--------' | Out-File -FilePath "$logFile" -Encoding UTF8 -Append

}
function getIpConfig {
    '--------' | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
    'Network Config' | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
    & Get-NetIPConfiguration -All | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
    '--------' | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
}

function getLastUpdated {
    '--------' | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
    'Update History' | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
    & Get-Hotfix | Sort-Object InstalledOn -Descending | Select-Object -First 10 | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
    '--------' | Out-File -FilePath "$logFile" -Encoding UTF8 -Append
}


getAdminGroup
getServices
getHardwareConfig
osInformation
getIpConfig
getLastUpdated

& explorer.exe $logFile 