# Remove NatNAT network without confirmation prompt
Remove-NetNat -Name "NatNAT" -Confirm:$false

# Remove NatSwitch if it exists
$natSwitch = Get-VMSwitch | Where-Object {$_.Name -eq "NatSwitch"}
if ($natSwitch) {
    Remove-VMSwitch -Name "NatSwitch" -Force
    Write-Host "NatSwitch has been removed."
} else {
    Write-Host "NatSwitch does not exist."
}

# Remove ExternalSwitch if it exists
$externalSwitch = Get-VMSwitch | Where-Object {$_.Name -eq "ExternalSwitch"}
if ($externalSwitch) {
    Remove-VMSwitch -Name "ExternalSwitch" -Force
    Write-Host "ExternalSwitch has been removed."
} else {
    Write-Host "ExternalSwitch does not exist."
}

# Remove PrivateSwitch if it exists
$privateSwitch = Get-VMSwitch | Where-Object {$_.Name -eq "PrivateSwitch"}
if ($privateSwitch) {
    Remove-VMSwitch -Name "PrivateSwitch" -Force
    Write-Host "PrivateSwitch has been removed."
} else {
    Write-Host "PrivateSwitch does not exist."
}
