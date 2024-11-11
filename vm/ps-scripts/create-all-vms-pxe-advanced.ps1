# PowerShell Script to Execute VM Setup Scripts with Enhanced Error Handling, Logging, and Best Practices

# Parameterize the path to the directory containing the VM scripts
param (
    [string]$scriptDir = "C:\lab\vm\ps-scripts"
)

# Define an array of script names, excluding pfsense-vm-pxe.ps1
$scripts = @(
    "centos-vm-pxe.ps1",
    "ubuntu-vm-pxe.ps1",
    "fedora-vm-pxe.ps1",
    "debian-vm-pxe.ps1",
    "kali-vm-pxe.ps1"
)

# Initialize logging and error tracking
$logFile = Join-Path -Path $scriptDir -ChildPath "orchestration_log.txt"
$errors = @{}

# Function to execute a script and log the outcome
function Execute-Script {
    param (
        [string]$scriptPath
    )

    try {
        $scriptName = Split-Path -Path $scriptPath -Leaf
        Write-Host "Starting $scriptName..."
        Write-Output "[$(Get-Date)] Starting $scriptName..." | Out-File -FilePath $logFile -Append

        # Execute the script
        & $scriptPath -ErrorAction Stop

        Write-Host "$scriptName completed successfully."
        Write-Output "[$(Get-Date)] $scriptName completed successfully." | Out-File -FilePath $logFile -Append
    }
    catch {
        Write-Host "Error in $scriptName: $_"
        Write-Output "[$(Get-Date)] Error in $scriptName: $_" | Out-File -FilePath $logFile -Append

        # Add to error tracking
        $errors[$scriptName] = $_
    }
}

# Main script execution loop
Write-Host "Executing all VM creation scripts..."
Write-Output "[$(Get-Date)] Starting VM creation scripts." | Out-File -FilePath $logFile -Append

foreach ($script in $scripts) {
    $scriptPath = Join-Path -Path $scriptDir -ChildPath $script
    if (Test-Path $scriptPath) {
        Execute-Script -scriptPath $scriptPath
    } else {
        Write-Host "Script $script does not exist in $scriptDir."
        Write-Output "[$(Get-Date)] Script $script does not exist in $scriptDir." | Out-File -FilePath $logFile -Append
        $errors[$script] = "Script not found"
    }
}

# Summary of execution
Write-Host "All VM creation scripts have been executed."
Write-Output "[$(Get-Date)] All VM creation scripts have been executed." | Out-File -FilePath $logFile -Append

if ($errors.Count -gt 0) {
    Write-Host "Some scripts encountered errors:"
    foreach ($key in $errors.Keys) {
        Write-Host "$key: $($errors[$key])"
        Write-Output "[$(Get-Date)] $key: $($errors[$key])" | Out-File -FilePath $logFile -Append
    }
} else {
    Write-Host "All scripts executed successfully."
    Write-Output "[$(Get-Date)] All scripts executed successfully." | Out-File -FilePath $logFile -Append
}
