# CentOS Setup Script with DVD device and ISO mount

# Define directory structure
$isoDir = "C:\lab\vm\iso-images"
$diskDir = "C:\lab\vm\hdds"
New-Item -ItemType Directory -Force -Path $isoDir, $diskDir

# Download CentOS ISO if not already downloaded
$centosIsoPath = "$isoDir\CentOS-Stream-9-latest-x86_64-dvd1.iso"
if (-Not (Test-Path $centosIsoPath)) {
    $centosIsoUrl = "https://mirrors.centos.org/mirrorlist?path=/9-stream/BaseOS/x86_64/iso/CentOS-Stream-9-latest-x86_64-dvd1.iso&redirect=1&protocol=https"
    Invoke-WebRequest -Uri $centosIsoUrl -OutFile $centosIsoPath
    Write-Host "CentOS ISO downloaded."
} else {
    Write-Host "CentOS ISO already exists."
}

# Create CentOS VM with specified parameters
$centosVhdPath = "$diskDir\1. centos.vhdx"
New-VM -Name "1. centos" -MemoryStartupBytes 6GB -NewVHDPath $centosVhdPath -NewVHDSizeBytes 60GB -Generation 2
Set-VMProcessor -VMName "1. centos" -Count 2
Set-VMMemory -VMName "1. centos" -DynamicMemoryEnabled $true -MinimumBytes 6GB

# Find the default network adapter and connect it to the NatSwitch
Get-VMNetworkAdapter -VMName "1. centos" | Connect-VMNetworkAdapter -SwitchName "NatSwitch"

# Add DVD drive to the VM and mount the ISO
$dvdDrive = Add-VMDvdDrive -VMName "1. centos" -ControllerNumber 0 -ControllerLocation 1
Set-VMDvdDrive -VMName "1. centos" -Path $centosIsoPath

# Disable Secure Boot for CentOS installation
Set-VMFirmware -VMName "1. centos" -EnableSecureBoot Off

# Set the boot order to boot from DVD first
$dvdDrive = Get-VMDvdDrive -VMName "1. centos"
Set-VMFirmware -VMName "1. centos" -FirstBootDevice $dvdDrive

Write-Host "CentOS VM has been created with the ISO mounted and the DVD drive attached."
