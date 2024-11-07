# Kali Linux Setup Script with DVD device and ISO mount

# Define directory structure
$isoDir = "C:\lab\vm\iso-images"
$diskDir = "C:\lab\vm\hdds"
New-Item -ItemType Directory -Force -Path $isoDir, $diskDir

# Download Kali Linux ISO if not already downloaded
$kaliIsoPath = "$isoDir\kali-linux-2024.2-installer-amd64.iso"
if (-Not (Test-Path $kaliIsoPath)) {
    $kaliIsoUrl = "https://cdimage.kali.org/kali-2024.2/kali-linux-2024.2-installer-amd64.iso"
    Invoke-WebRequest -Uri $kaliIsoUrl -OutFile $kaliIsoPath
    Write-Host "Kali Linux ISO downloaded."
} else {
    Write-Host "Kali Linux ISO already exists."
}

# Create Kali VM with specified parameters
$kaliVhdPath = "$diskDir\5. kali.vhdx"
New-VM -Name "5. kali" -MemoryStartupBytes 2GB -NewVHDPath $kaliVhdPath -NewVHDSizeBytes 80GB -Generation 2
Set-VMProcessor -VMName "5. kali" -Count 2
Set-VMMemory -VMName "5. kali" -DynamicMemoryEnabled $true -MinimumBytes 2GB

# Find the default network adapter and connect it to the NatSwitch
Get-VMNetworkAdapter -VMName "5. kali" | Connect-VMNetworkAdapter -SwitchName "NatSwitch"

# Add DVD drive to the VM and mount the Kali ISO
$dvdDrive = Add-VMDvdDrive -VMName "5. kali" -ControllerNumber 0 -ControllerLocation 1
Set-VMDvdDrive -VMName "5. kali" -Path $kaliIsoPath

# Disable Secure Boot for Kali installation
Set-VMFirmware -VMName "5. kali" -EnableSecureBoot Off

# Set the boot order to boot from the DVD drive first
$dvdDrive = Get-VMDvdDrive -VMName "5. kali"
Set-VMFirmware -VMName "5. kali" -FirstBootDevice $dvdDrive

Write-Host "Kali VM has been created with the ISO mounted and the DVD drive attached."
