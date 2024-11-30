# CentOS Setup Script for PXE Boot

# Define directory structure for virtual machine files
$diskDir = "C:\lab\vm\hdds"
New-Item -ItemType Directory -Force -Path $diskDir

# Create CentOS VM with specified parameters
$centosVhdPath = "$diskDir\1. centos.vhdx"
New-VM -Name "1. centos" -MemoryStartupBytes 6GB -NewVHDPath $centosVhdPath -NewVHDSizeBytes 60GB -Generation 2
Set-VMProcessor -VMName "1. centos" -Count 2
Set-VMMemory -VMName "1. centos" -DynamicMemoryEnabled $true -MinimumBytes 6GB

# Find the default network adapter and connect it to the NatSwitch
Get-VMNetworkAdapter -VMName "1. centos" | Connect-VMNetworkAdapter -SwitchName "NatSwitch"

# Disable Secure Boot for CentOS installation over PXE
Set-VMFirmware -VMName "1. centos" -EnableSecureBoot Off

# Set the boot order to boot from the network adapter first
$netAdapter = Get-VMNetworkAdapter -VMName "1. centos"
Set-VMFirmware -VMName "1. centos" -FirstBootDevice $netAdapter

Write-Host "CentOS VM has been created and configured to boot from the network for PXE installation."
