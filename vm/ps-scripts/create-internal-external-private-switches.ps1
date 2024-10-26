# Create NatSwitch if it doesn't exist
$natSwitch = Get-VMSwitch | Where-Object {$_.Name -eq "NatSwitch"}
if (-Not $natSwitch) {
    # Step 1: Create the internal switch
    New-VMSwitch -SwitchName "NatSwitch" -SwitchType Internal
    Write-Host "NatSwitch has been created."
    
    # Step 2: Assign an IP address to NatSwitch
    New-NetIPAddress -IPAddress 192.168.100.1 -PrefixLength 24 -InterfaceAlias "vEthernet (NatSwitch)" -DefaultGateway 192.168.100.1
    Write-Host "IP address assigned to NatSwitch."
    
    # Step 3: Create the NAT network for NatSwitch
    New-NetNat -Name "NatNAT" -InternalIPInterfaceAddressPrefix "192.168.100.0/24"
    Write-Host "NatNAT has been created."
} else {
    Write-Host "NatSwitch and NatNAT already exist."
}

# Get the first available physical network adapter
$physicalAdapters = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' -and $_.Virtual -eq $false }

if ($physicalAdapters.Count -eq 0) {
    Write-Host "Error: No physical network adapters found."
    exit
}

$externalAdapter = $physicalAdapters[0].Name

# Check if the external switch already exists
$externalSwitch = Get-VMSwitch | Where-Object {$_.Name -eq "ExternalSwitch"}
if (-Not $externalSwitch) {
    # Step 4: Create an external switch named "ExternalSwitch" associated with the first available physical adapter
    New-VMSwitch -SwitchName "ExternalSwitch" -NetAdapterName $externalAdapter
    Write-Host "ExternalSwitch has been created and associated with '$externalAdapter'."
} else {
    Write-Host "ExternalSwitch already exists."
}

# Step 5: Create the private switch named "PrivateSwitch"
$privateSwitch = Get-VMSwitch | Where-Object {$_.Name -eq "PrivateSwitch"}
if (-Not $privateSwitch) {
    New-VMSwitch -Name "PrivateSwitch" -SwitchType Private
    Write-Host "PrivateSwitch has been created."
} else {
    Write-Host "PrivateSwitch already exists."
}
