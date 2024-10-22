# Ubuntu Server Setup Script with DVD device and ISO mount

# Define directory structure
$isoDir = "C:\vm\iso-images"
$diskDir = "C:\vm\hdds"
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
$ubuntuVhdPath = "$diskDir\ubuntu.vhdx"
New-VM -Name "ubuntu" -MemoryStartupBytes 4GB -NewVHDPath $ubuntuVhdPath -NewVHDSizeBytes 80GB -Generation 2
Set-VMProcessor -VMName "ubuntu" -Count 2
Set-VMMemory -VMName "ubuntu" -DynamicMemoryEnabled $true -MinimumBytes 4GB

# Find the default network adapter and connect it to the NatSwitch
Get-VMNetworkAdapter -VMName "ubuntu" | Connect-VMNetworkAdapter -SwitchName "NatSwitch"

# Add DVD drive to the VM and mount the Ubuntu ISO
$dvdDrive = Add-VMDvdDrive -VMName "ubuntu" -ControllerNumber 0 -ControllerLocation 1
Set-VMDvdDrive -VMName "ubuntu" -Path $ubuntuIsoPath

# Set the boot order to boot from the DVD drive first
$dvdDrive = Get-VMDvdDrive -VMName "ubuntu"
Set-VMFirmware -VMName "ubuntu" -FirstBootDevice $dvdDrive

# Disable Secure Boot for Ubuntu installation
Set-VMFirmware -VMName "ubuntu" -EnableSecureBoot Off

Write-Host "Ubuntu VM has been created with the ISO mounted and the DVD drive attached."