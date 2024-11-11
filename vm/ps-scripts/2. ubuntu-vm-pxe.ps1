# Ubuntu Server Setup Script for PXE Boot

# Define directory structure for virtual machine files
$diskDir = "C:\lab\vm\hdds"
New-Item -ItemType Directory -Force -Path $diskDir

# Create Ubuntu VM with specified parameters
$ubuntuVhdPath = "$diskDir\2. ubuntu.vhdx"
New-VM -Name "2. ubuntu" -MemoryStartupBytes 4GB -NewVHDPath $ubuntuVhdPath -NewVHDSizeBytes 60GB -Generation 2
Set-VMProcessor -VMName "2. ubuntu" -Count 2
Set-VMMemory -VMName "2. ubuntu" -DynamicMemoryEnabled $true -MinimumBytes 4GB

# Find the default network adapter and connect it to the NatSwitch
Get-VMNetworkAdapter -VMName "2. ubuntu" | Connect-VMNetworkAdapter -SwitchName "NatSwitch"

# Disable Secure Boot for Ubuntu installation over PXE
Set-VMFirmware -VMName "2. ubuntu" -EnableSecureBoot Off

# Set the boot order to boot from the network adapter first
$netAdapter = Get-VMNetworkAdapter -VMName "2. ubuntu"
Set-VMFirmware -VMName "2. ubuntu" -FirstBootDevice $netAdapter

Write-Host "Ubuntu VM has been created and configured to boot from the network for PXE installation."
