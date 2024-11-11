# Kali Linux Setup Script for PXE Boot

# Define directory structure for virtual machine files
$diskDir = "C:\lab\vm\hdds"
New-Item -ItemType Directory -Force -Path $diskDir

# Create Kali VM with specified parameters
$kaliVhdPath = "$diskDir\kali.vhdx"
New-VM -Name "kali" -MemoryStartupBytes 2GB -NewVHDPath $kaliVhdPath -NewVHDSizeBytes 60GB -Generation 2
Set-VMProcessor -VMName "kali" -Count 2
Set-VMMemory -VMName "kali" -DynamicMemoryEnabled $true -MinimumBytes 2GB

# Find the default network adapter and connect it to the NatSwitch
Get-VMNetworkAdapter -VMName "kali" | Connect-VMNetworkAdapter -SwitchName "NatSwitch"

# Disable Secure Boot for Kali installation over PXE
Set-VMFirmware -VMName "kali" -EnableSecureBoot Off

# Set the boot order to boot from the network adapter first
$netAdapter = Get-VMNetworkAdapter -VMName "kali"
Set-VMFirmware -VMName "kali" -FirstBootDevice $netAdapter

Write-Host "Kali VM has been created and configured to boot from the network for PXE installation."
