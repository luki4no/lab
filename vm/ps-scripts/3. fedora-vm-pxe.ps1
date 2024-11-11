# Fedora Server Setup Script for PXE Boot

# Define directory structure for virtual machine files
$diskDir = "C:\lab\vm\hdds"
New-Item -ItemType Directory -Force -Path $diskDir

# Create Fedora VM with specified parameters
$fedoraVhdPath = "$diskDir\3. fedora.vhdx"
New-VM -Name "3. fedora" -MemoryStartupBytes 2GB -NewVHDPath $fedoraVhdPath -NewVHDSizeBytes 60GB -Generation 2
Set-VMProcessor -VMName "3. fedora" -Count 1
Set-VMMemory -VMName "3. fedora" -DynamicMemoryEnabled $true -MinimumBytes 2GB

# Find the default network adapter and connect it to the NatSwitch
Get-VMNetworkAdapter -VMName "3. fedora" | Connect-VMNetworkAdapter -SwitchName "NatSwitch"

# Disable Secure Boot for Fedora installation over PXE
Set-VMFirmware -VMName "3. fedora" -EnableSecureBoot Off

# Set the boot order to boot from the network adapter first
$netAdapter = Get-VMNetworkAdapter -VMName "3. fedora"
Set-VMFirmware -VMName "3. fedora" -FirstBootDevice $netAdapter

Write-Host "Fedora VM has been created and configured to boot from the network for PXE installation."
