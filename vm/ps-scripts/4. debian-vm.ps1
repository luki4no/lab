# Debian Setup Script with DVD device and ISO mount

# Define directory structure
$isoDir = "C:\lab\vm\iso-images"
$diskDir = "C:\lab\vm\hdds"
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
$debianVhdPath = "$diskDir\4. debian.vhdx"
New-VM -Name "4. debian" -MemoryStartupBytes 2GB -NewVHDPath $debianVhdPath -NewVHDSizeBytes 80GB -Generation 2
Set-VMProcessor -VMName "4. debian" -Count 1
Set-VMMemory -VMName "4. debian" -DynamicMemoryEnabled $true -MinimumBytes 2GB

# Find the default network adapter and connect it to the NatSwitch
Get-VMNetworkAdapter -VMName "4. debian" | Connect-VMNetworkAdapter -SwitchName "NatSwitch"

# Add DVD drive to the VM and mount the Debian ISO
$dvdDrive = Add-VMDvdDrive -VMName "4. debian" -ControllerNumber 0 -ControllerLocation 1
Set-VMDvdDrive -VMName "4. debian" -Path $debianIsoPath

# Disable Secure Boot for Debian installation
Set-VMFirmware -VMName "4. debian" -EnableSecureBoot Off

# Set the boot order to boot from DVD first
$dvdDrive = Get-VMDvdDrive -VMName "4. debian"
Set-VMFirmware -VMName "4. debian" -FirstBootDevice $dvdDrive

Write-Host "Debian VM has been created with the ISO mounted and the DVD drive attached."
