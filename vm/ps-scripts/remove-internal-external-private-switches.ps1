# Define the switches and NAT network to be removed
$switches = @("NatSwitch", "ExternalSwitch", "PrivateSwitch")
$natName = "NatNAT"

# Function to remove a NAT network if it exists
function Remove-NatNetwork {
    param ([string]$Name)
    $nat = Get-NetNat | Where-Object { $_.Name -eq $Name }
    if ($nat) {
        Remove-NetNat -Name $Name -Confirm:$false
        Write-Host "$Name has been removed."
    } else {
        Write-Host "$Name does not exist."
    }
}

# Function to remove a virtual switch if it exists
function Remove-VirtualSwitch {
    param ([string]$SwitchName)
    $switch = Get-VMSwitch | Where-Object { $_.Name -eq $SwitchName }
    if ($switch) {
        Remove-VMSwitch -Name $SwitchName -Force
        Write-Host "$SwitchName has been removed."
    } else {
        Write-Host "$SwitchName does not exist."
    }
}

# Remove the NAT network
Write-Host "Removing NAT network..."
Remove-NatNetwork -Name $natName

# Remove each switch in the list
Write-Host "Removing virtual switches..."
foreach ($switch in $switches) {
    Remove-VirtualSwitch -SwitchName $switch
}

Write-Host "Cleanup complete."
