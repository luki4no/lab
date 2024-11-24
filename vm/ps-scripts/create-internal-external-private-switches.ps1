# Function to prompt the user to select a network adapter
function Select-NetworkAdapter {
    # Include both "Up" and "Disconnected" physical adapters
    $adapters = Get-NetAdapter | Where-Object { $_.Virtual -eq $false -and ($_.Status -eq 'Up' -or $_.Status -eq 'Disconnected') }

    if (-Not $adapters) {
        Write-Host "Error: No physical network adapters are currently available."
        exit
    }

    # Display available adapters with a user-friendly numbered list
    Write-Host "Available Network Adapters:"
    $index = 1
    $adapters | ForEach-Object { 
        Write-Host "$index. $($_.Name) - $($_.InterfaceDescription)"
        $index++
    }

    # Keep prompting until a valid selection is made
    do {
        $choice = Read-Host "Enter the number of the adapter you want to use"
        if ($choice -match '^\d+$' -and [int]$choice -ge 1 -and [int]$choice -le $adapters.Count) {
            return $adapters[([int]$choice - 1)]
        } else {
            Write-Host "Invalid selection. Please enter a number between 1 and $($adapters.Count)."
        }
    } while ($true)
}

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

# Prompt the user to select a network adapter
$desiredAdapter = Select-NetworkAdapter

$externalAdapter = $desiredAdapter.Name

# Check if the external switch already exists
$externalSwitch = Get-VMSwitch | Where-Object {$_.Name -eq "ExternalSwitch"}
if (-Not $externalSwitch) {
    # Step 4: Create an external switch named "ExternalSwitch" associated with the selected adapter
    New-VMSwitch -SwitchName "ExternalSwitch" -NetAdapterName $externalAdapter
    Write-Host "ExternalSwitch has been created and associated with '$externalAdapter' ($desiredAdapter.InterfaceDescription)."
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

Write-Host "Creation complete."
