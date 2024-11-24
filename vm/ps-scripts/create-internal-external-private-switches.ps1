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

# Function to remove an IP address associated with a virtual switch
function Remove-IPConfiguration {
    param ([string]$SwitchName)
    $ipConfig = Get-NetIPAddress | Where-Object { $_.InterfaceAlias -eq "vEthernet ($SwitchName)" }
    if ($ipConfig) {
        Remove-NetIPAddress -InterfaceAlias "vEthernet ($SwitchName)" -Confirm:$false
        Write-Host "IP address removed for $SwitchName."
    } else {
        Write-Host "No IP address configured for $SwitchName."
    }
}

# Remove the NAT network
Write-Host "Removing NAT network..."
Remove-NatNetwork -Name $natName

# Remove each switch and its associated IP configuration
Write-Host "Removing virtual switches and their IP configurations..."
foreach ($switch in $switches) {
    Remove-IPConfiguration -SwitchName $switch
    Remove-VirtualSwitch -SwitchName $switch
}

# Verification Step
Write-Host "Verifying cleanup..."
# Check for remaining switches
$switchesRemaining = Get-VMSwitch | Where-Object { $_.Name -in $switches }
if ($switchesRemaining) {
    Write-Host "The following switches were not removed:"
    $switchesRemaining | ForEach-Object { Write-Host "- $($_.Name)" }
} else {
    Write-Host "All virtual switches have been successfully removed."
}

# Check for remaining NAT network
$nat = Get-NetNat | Where-Object { $_.Name -eq $natName }
if ($nat) {
    Write-Host "NAT network still exists: $($nat.Name)"
} else {
    Write-Host "NAT network has been successfully removed."
}

# Display the current configuration with commands shown
Write-Host "Executing command: Get-VMSwitch"
Get-VMSwitch

Write-Host "Executing command: Get-NetNat"
Get-NetNat

Write-Host "Cleanup complete."
