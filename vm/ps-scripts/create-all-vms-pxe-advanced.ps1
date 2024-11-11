# PowerShell Script to Execute VM Setup Scripts with User Selection Menu, Enhanced Error Handling, and Logging

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

# Function to display the menu and get the user's choice
function Show-Menu {
    Write-Host "Please choose an option:"
    for ($i = 0; $i -lt $scripts.Count; $i++) {
        Write-Host "$($i + 1). ${scripts[$i]}"
    }
    Write-Host "$($scripts.Count + 1). Install All VMs"
    Write-Host "$($scripts.Count + 2). Exit"

    $choice = Read-Host "Enter the number of your choice"
    return [int]$choice
}

# Main script execution logic with user menu
do {
    $choice = Show-Menu

    if ($choice -ge 1 -and $choice -le $scripts.Count) {
        # Execute a single selected script
        $scriptPath = Join-Path -Path $scriptDir -ChildPath $scripts[$choice - 1]
        if (Test-Path $scriptPath) {
            Execute-Script -scriptPath $scriptPath
        } else {
            Write-Host "Script ${scripts[$choice - 1]} does not exist in $scriptDir."
            Write-Output "[$(Get-Date)] Script ${scripts[$choice - 1]} does not exist in $scriptDir." | Out-File -FilePath $logFile -Append
            $errors[$scripts[$choice - 1]] = "Script not found"
        }
    } elseif ($choice -eq $scripts.Count + 1) {
        # Execute all scripts
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

        Write-Host "All VM creation scripts have been executed."
        Write-Output "[$(Get-Date)] All VM creation scripts have been executed." | Out-File -FilePath $logFile -Append
    } elseif ($choice -eq $scripts.Count + 2) {
        Write-Host "Exiting script."
        break
    } else {
        Write-Host "Invalid choice. Please enter a valid number."
    }
} while ($choice -ne $scripts.Count + 2)

# Summary of execution
if ($errors.Count -gt 0) {
    Write-Host "Some scripts encountered errors:"
    foreach ($key in $errors.Keys) {
        Write-Host "$key: $($errors[$key])"
        Write-Output "[$(Get-Date)] $key: $($errors[$key])" | Out-File -FilePath $logFile -Append
    }
} else {
    Write-Host "All selected scripts executed successfully."
    Write-Output "[$(Get-Date)] All selected scripts executed successfully." | Out-File -FilePath $logFile -Append
}
