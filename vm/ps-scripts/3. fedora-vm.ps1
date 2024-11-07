# Fedora Server Setup Script with DVD device and ISO mount

# Define directory structure
$isoDir = "C:\lab\vm\iso-images"
$diskDir = "C:\lab\vm\hdds"
New-Item -ItemType Directory -Force -Path $isoDir, $diskDir

# Download Fedora Server ISO if not already downloaded
$fedoraIsoPath = "$isoDir\Fedora-Server-dvd-x86_64-41-1.4.iso"
if (-Not (Test-Path $fedoraIsoPath)) {
    $fedoraIsoUrl = "https://download.fedoraproject.org/pub/fedora/linux/releases/41/Server/x86_64/iso/Fedora-Server-dvd-x86_64-41-1.4.iso"
    Invoke-WebRequest -Uri $fedoraIsoUrl -OutFile $fedoraIsoPath
    Write-Host "Fedora Netinstall ISO downloaded."
} else {
    Write-Host "Fedora Netinstall ISO already exists."
}

# Create Fedora VM with specified parameters
$fedoraVhdPath = "$diskDir\3. fedora.vhdx"
New-VM -Name "3. fedora" -MemoryStartupBytes 2GB -NewVHDPath $fedoraVhdPath -NewVHDSizeBytes 60GB -Generation 2
Set-VMProcessor -VMName "3. fedora" -Count 1
Set-VMMemory -VMName "3. fedora" -DynamicMemoryEnabled $true -MinimumBytes 2GB

# Find the default network adapter and connect it to the NatSwitch
Get-VMNetworkAdapter -VMName "3. fedora" | Connect-VMNetworkAdapter -SwitchName "NatSwitch"

# Add DVD drive to the VM and mount the Fedora ISO
$dvdDrive = Add-VMDvdDrive -VMName "3. fedora" -ControllerNumber 0 -ControllerLocation 1
Set-VMDvdDrive -VMName "3. fedora" -Path $fedoraIsoPath

# Disable Secure Boot for Fedora installation
Set-VMFirmware -VMName "3. fedora" -EnableSecureBoot Off

# Set the boot order to boot from the DVD drive first
$dvdDrive = Get-VMDvdDrive -VMName "3. fedora"
Set-VMFirmware -VMName "3. fedora" -FirstBootDevice $dvdDrive

Write-Host "Fedora VM has been created with the ISO mounted and the DVD drive attached."
