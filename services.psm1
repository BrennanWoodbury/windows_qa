Import-Module .\config.ps1
function services {
    foreach ($name in $serviceNames) {
        if (Get-Service -Name $name -ErrorAction SilentlyContinue) {
            $service = Get-Service -Name $name

            if ($service.Status -eq 'Running') {
                Write-Host "$name is installed and running"
            }
            else {
                Write-Host "$name is installed, but is not running"
            }
        }
        else {
            Write-Host "$name is not installed"
        }
    }
}