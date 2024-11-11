# Stop the script if any error occurs
$ErrorActionPreference = "Stop"

# Path to the directory containing the VM scripts
$scriptDir = "C:\lab\vm\ps-scripts"

# Array of script names with numbering, as they appear in the directory
$scripts = @(
    "1. centos-vm.ps1",
    "2. ubuntu-vm.ps1",
    "3. fedora-vm.ps1",
    "4. debian-vm.ps1",
    "5. kali-vm.ps1"
)

# Descriptive names for each option
$descriptions = @(
    "RedHat - CentOS (Stream 9)",
    "Debian - Ubuntu Server (24.04.1)",
    "RedHat - Fedora Server (41-1.4)",
    "Debian - Debian (12.7.0)",
    "Debian - Kali (2024.3)"
)

# Function to display the menu and get the user's choice
function Show-Menu {
    Write-Host "`nThis script will create the Hyper-V VM profile(s), and mount the corresponding ISO-image`n"
    Write-Host "Please choose an option:"
    for ($i = 0; $i -lt $descriptions.Count; $i++) {
        Write-Host "$($i + 1). $($descriptions[$i])"
    }
    Write-Host "$($descriptions.Count + 1). >>> Install All VMs <<<"
    Write-Host "$($descriptions.Count + 2). Exit"

    $choice = Read-Host "Enter the number of your choice"
    return [int]$choice
}

# Function to execute a VM script
function Execute-Script {
    param (
        [string]$scriptName
    )
    $scriptPath = Join-Path -Path $scriptDir -ChildPath $scriptName
    if (Test-Path $scriptPath) {
        Write-Host "Executing $scriptName ..."
        try {
            & $scriptPath
            Write-Host "$scriptName completed successfully."
        } catch {
            Write-Host "Error executing $($scriptName): $_"
        }
    } else {
        Write-Host "Script $($scriptName) does not exist in $scriptDir."
    }
}

# Main script execution logic with user menu
do {
    $choice = Show-Menu

    if ($choice -ge 1 -and $choice -le $scripts.Count) {
        # Execute a single selected script
        $scriptName = $scripts[$choice - 1]
        Execute-Script -scriptName $scriptName
    } elseif ($choice -eq $scripts.Count + 1) {
        # Execute all scripts
        Write-Host "Executing all VM creation scripts..."
        foreach ($scriptName in $scripts) {
            Execute-Script -scriptName $scriptName
        }
        Write-Host "All VM creation scripts have been executed."
    } elseif ($choice -eq $scripts.Count + 2) {
        Write-Host "Exiting script."
        break
    } else {
        Write-Host "Invalid choice. Please enter a valid number."
    }
} while ($choice -ne $scripts.Count + 2)
