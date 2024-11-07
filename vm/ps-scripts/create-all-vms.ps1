# Path to the directory containing the VM scripts
$scriptDir = "C:\lab\vm\ps-scripts"

# Array of script names
$scripts = @(
    "pfsense-vm.ps1",
    "centos-vm.ps1",
    "ubuntu-vm.ps1",
    "fedora-vm.ps1",
    "debian-vm.ps1",
    "kali-vm.ps1"
)

# Iterate through each script and execute it
foreach ($script in $scripts) {
    $scriptPath = Join-Path -Path $scriptDir -ChildPath $script
    if (Test-Path $scriptPath) {
        Write-Host "Executing $script ..."
        & $scriptPath
    } else {
        Write-Host "Script $script does not exist in $scriptDir."
    }
}

Write-Host "All VM creation scripts have been executed."