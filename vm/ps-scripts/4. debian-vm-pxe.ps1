# Debian Setup Script for PXE Boot

# Define directory structure for virtual machine files
$diskDir = "C:\lab\vm\hdds"
New-Item -ItemType Directory -Force -Path $diskDir

# Create Debian VM with specified parameters
$debianVhdPath = "$diskDir\4. debian.vhdx"
New-VM -Name "4. debian" -MemoryStartupBytes 2GB -NewVHDPath $debianVhdPath -NewVHDSizeBytes 60GB -Generation 2
Set-VMProcessor -VMName "4. debian" -Count 1
Set-VMMemory -VMName "4. debian" -DynamicMemoryEnabled $true -MinimumBytes 2GB

# Find the default network adapter and connect it to the NatSwitch
Get-VMNetworkAdapter -VMName "4. debian" | Connect-VMNetworkAdapter -SwitchName "NatSwitch"

# Disable Secure Boot for Debian installation over PXE
Set-VMFirmware -VMName "4. debian" -EnableSecureBoot Off

# Set the boot order to boot from the network adapter first
$netAdapter = Get-VMNetworkAdapter -VMName "4. debian"
Set-VMFirmware -VMName "4. debian" -FirstBootDevice $netAdapter

Write-Host "Debian VM has been created and configured to boot from the network for PXE installation."
