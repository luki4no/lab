# Path to the directory containing the VM scripts
$scriptDir = "C:\lab\vm\ps-scripts"

# Array of script names with numbering, as they appear in the directory
$scripts = @(
    "1. centos-vm-pxe.ps1",
    "2. ubuntu-vm-pxe.ps1",
    "3. fedora-vm-pxe.ps1",
    "4. debian-vm-pxe.ps1",
    "5. kali-vm-pxe.ps1"
)

# Descriptive names for each option
$descriptions = @(
    "RedHat - CentOS Stream 9",
    "Debian - Ubuntu Server 24.04.1",
    "RedHat - Fedora Server 41-1.4",
    "Debian - Debian 12.7.0",
    "Debian - Kali 2024.3"
)

# Function to display the menu and get the user's choice
function Show-Menu {
    Write-Host "`nPlease choose an option:"
    for ($i = 0; $i -lt $descriptions.Count; $i++) {
        Write-Host "$($i + 1). $($descriptions[$i])"
    }
    Write-Host "$($descriptions.Count + 1). >>> Install All VMs <<<"
    Write-Host "$($descriptions.Count + 2). Exit"

    $choice = Read-Host "Enter the number of your choice"
    return [int]$choice
}

# Main script execution logic with user menu
do {
    $choice = Show-Menu

    if ($choice -ge 1 -and $choice -le $scripts.Count) {
        # Execute a single selected script
        $scriptName = $scripts[$choice - 1]
        $scriptPath = Join-Path -Path $scriptDir -ChildPath $scriptName
        if (Test-Path $scriptPath) {
            Write-Host "Executing ${descriptions[$choice - 1]} ..."
            try {
                & $scriptPath
                Write-Host "${descriptions[$choice - 1]} completed successfully."
            } catch {
                Write-Host "Error executing ${descriptions[$choice - 1]}: ${_}"
            }
        } else {
            Write-Host "Script ${scriptName} does not exist in $scriptDir."
        }
    } elseif ($choice -eq $scripts.Count + 1) {
        # Execute all scripts
        Write-Host "Executing all VM creation scripts..."
        foreach ($scriptName in $scripts) {
            $scriptPath = Join-Path -Path $scriptDir -ChildPath $scriptName
            $description = $descriptions[$scripts.IndexOf($scriptName)]
            if (Test-Path $scriptPath) {
                Write-Host "Executing ${description} ..."
                try {
                    & $scriptPath
                    Write-Host "${description} completed successfully."
                } catch {
                    Write-Host "Error executing ${description}: ${_}"
                }
            } else {
                Write-Host "Script ${scriptName} does not exist in $scriptDir."
            }
        }
        Write-Host "All VM creation scripts have been executed."
    } elseif ($choice -eq $scripts.Count + 2) {
        Write-Host "Exiting script."
        break
    } else {
        Write-Host "Invalid choice. Please enter a valid number."
    }
} while ($choice -ne $scripts.Count + 2)
