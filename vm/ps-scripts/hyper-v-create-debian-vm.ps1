# Debian Setup Script with DVD device and ISO mount

# Define directory structure
$isoDir = "C:\vm\iso-images"
$diskDir = "C:\vm\hdds"
New-Item -ItemType Directory -Force -Path $isoDir, $diskDir

# Download Debian ISO if not already downloaded
$debianIsoPath = "$isoDir\debian-12.7.0-amd64-DVD-1.iso"
if (-Not (Test-Path $debianIsoPath)) {
    $debianIsoUrl = "https://cdimage.debian.org/debian-cd/current/amd64/iso-dvd/debian-12.7.0-amd64-DVD-1.iso"
    Invoke-WebRequest -Uri $debianIsoUrl -OutFile $debianIsoPath
    Write-Host "Debian ISO downloaded."
} else {
    Write-Host "Debian ISO already exists."
}

# Create Debian VM with specified parameters
$debianVhdPath = "$diskDir\debian.vhdx"
New-VM -Name "debian" -MemoryStartupBytes 4GB -NewVHDPath $debianVhdPath -NewVHDSizeBytes 80GB -Generation 2
Set-VMProcessor -VMName "debian" -Count 2
Set-VMMemory -VMName "debian" -DynamicMemoryEnabled $true -MinimumBytes 4GB

# Find the default network adapter and connect it to the NatSwitch
Get-VMNetworkAdapter -VMName "debian" | Connect-VMNetworkAdapter -SwitchName "NatSwitch"

# Add DVD drive to the VM and mount the Debian ISO
$dvdDrive = Add-VMDvdDrive -VMName "debian" -ControllerNumber 0 -ControllerLocation 1
Set-VMDvdDrive -VMName "debian" -Path $debianIsoPath

# Disable Secure Boot for Debian installation
Set-VMFirmware -VMName "debian" -EnableSecureBoot Off

# Set the boot order to boot from DVD first
$dvdDrive = Get-VMDvdDrive -VMName "debian"
Set-VMFirmware -VMName "debian" -FirstBootDevice $dvdDrive

Write-Host "Debian VM has been created with the ISO mounted and the DVD drive attached."