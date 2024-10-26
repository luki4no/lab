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
$centosVhdPath = "$diskDir\centos.vhdx"
New-VM -Name "centos" -MemoryStartupBytes 8GB -NewVHDPath $centosVhdPath -NewVHDSizeBytes 80GB -Generation 2
Set-VMProcessor -VMName "centos" -Count 2
Set-VMMemory -VMName "centos" -DynamicMemoryEnabled $true -MinimumBytes 8GB

# Find the default network adapter and connect it to the NatSwitch
Get-VMNetworkAdapter -VMName "centos" | Connect-VMNetworkAdapter -SwitchName "NatSwitch"

# Add DVD drive to the VM and mount the ISO
$dvdDrive = Add-VMDvdDrive -VMName "centos" -ControllerNumber 0 -ControllerLocation 1
Set-VMDvdDrive -VMName "centos" -Path $centosIsoPath

# Disable Secure Boot for CentOS installation
Set-VMFirmware -VMName "centos" -EnableSecureBoot Off

# Set the boot order to boot from DVD first
$dvdDrive = Get-VMDvdDrive -VMName "centos"
Set-VMFirmware -VMName "centos" -FirstBootDevice $dvdDrive

Write-Host "CentOS VM has been created with the ISO mounted and the DVD drive attached."
