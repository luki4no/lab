# Path to the directory containing the VM scripts
$scriptDir = "C:\lab\vm\ps-scripts"

# Array of script names, excluding pfsense-vm-pxe.ps1
$scripts = @(
    "centos-vm-pxe.ps1",
    "ubuntu-vm-pxe.ps1",
    "fedora-vm-pxe.ps1",
    "debian-vm-pxe.ps1",
    "kali-vm-pxe.ps1"
)

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
            Write-Host "Executing ${scripts[$choice - 1]} ..."
            & $scriptPath
        } else {
            Write-Host "Script ${scripts[$choice - 1]} does not exist in $scriptDir."
        }
    } elseif ($choice -eq $scripts.Count + 1) {
        # Execute all scripts
        Write-Host "Executing all VM creation scripts..."
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
    } elseif ($choice -eq $scripts.Count + 2) {
        Write-Host "Exiting script."
        break
    } else {
        Write-Host "Invalid choice. Please enter a valid number."
    }
} while ($choice -ne $scripts.Count + 2)
