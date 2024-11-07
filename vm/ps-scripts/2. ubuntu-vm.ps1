# Ubuntu Server Setup Script with DVD device and ISO mount

# Define directory structure
$isoDir = "C:\lab\vm\iso-images"
$diskDir = "C:\lab\vm\hdds"
New-Item -ItemType Directory -Force -Path $isoDir, $diskDir

# Download Ubuntu Server ISO if not already downloaded
$ubuntuIsoPath = "$isoDir\ubuntu-24.04.1-live-server-amd64.iso"
if (-Not (Test-Path $ubuntuIsoPath)) {
    $ubuntuIsoUrl = "https://ubuntu.com/download/server/thank-you?version=24.04.1&architecture=amd64&lts=true"
    Invoke-WebRequest -Uri $ubuntuIsoUrl -OutFile $ubuntuIsoPath
    Write-Host "Ubuntu Server ISO downloaded."
} else {
    Write-Host "Ubuntu Server ISO already exists."
}

# Create Ubuntu VM with specified parameters
$ubuntuVhdPath = "$diskDir\2. ubuntu.vhdx"
New-VM -Name "2. ubuntu" -MemoryStartupBytes 4GB -NewVHDPath $ubuntuVhdPath -NewVHDSizeBytes 60GB -Generation 2
Set-VMProcessor -VMName "2. ubuntu" -Count 2
Set-VMMemory -VMName "2. ubuntu" -DynamicMemoryEnabled $true -MinimumBytes 4GB

# Find the default network adapter and connect it to the NatSwitch
Get-VMNetworkAdapter -VMName "2. ubuntu" | Connect-VMNetworkAdapter -SwitchName "NatSwitch"

# Add DVD drive to the VM and mount the Ubuntu ISO
$dvdDrive = Add-VMDvdDrive -VMName "2. ubuntu" -ControllerNumber 0 -ControllerLocation 1
Set-VMDvdDrive -VMName "2. ubuntu" -Path $ubuntuIsoPath

# Set the boot order to boot from the DVD drive first
$dvdDrive = Get-VMDvdDrive -VMName "2. ubuntu"
Set-VMFirmware -VMName "2. ubuntu" -FirstBootDevice $dvdDrive

# Disable Secure Boot for Ubuntu installation
Set-VMFirmware -VMName "2. ubuntu" -EnableSecureBoot Off

Write-Host "Ubuntu VM has been created with the ISO mounted and the DVD drive attached."
