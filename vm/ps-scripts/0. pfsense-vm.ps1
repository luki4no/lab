# pfSense Setup Script with DVD device and ISO mount for Generation 1

# Define directory structure
$isoDir = "C:\lab\vm\iso-images"
$diskDir = "C:\lab\vm\hdds"
New-Item -ItemType Directory -Force -Path $isoDir, $diskDir

# Download pfSense ISO if not already downloaded
$centosIsoPath = "$isoDir\pfSense-CE-2.7.2-RELEASE-amd64.iso"
if (-Not (Test-Path $centosIsoPath)) {
    $centosIsoUrl = "https://mindrefinedde.sharepoint.com/sites/WB_CS_05/_layouts/15/download.aspx?SourceUrl=%2Fsites%2FWB%5FCS%5F05%2FFreigegebene%20Dokumente%2F%F0%9F%91%A9%E2%80%8D%F0%9F%8E%93%20Tutoring%2FISO%20images%2FpfSense%2DCE%2D2%2E7%2E2%2DRELEASE%2Damd64%2Eiso"
    Invoke-WebRequest -Uri $centosIsoUrl -OutFile $centosIsoPath
    Write-Host "pfSense ISO downloaded."
} else {
    Write-Host "pfSense ISO already exists."
}

# Create pfSense VM with specified parameters
$centosVhdPath = "$diskDir\pfsense.vhdx"
New-VM -Name "pfsense" -MemoryStartupBytes 2GB -NewVHDPath $centosVhdPath -NewVHDSizeBytes 60GB -Generation 1
Set-VMProcessor -VMName "pfsense" -Count 1
Set-VMMemory -VMName "pfsense" -DynamicMemoryEnabled $true -MinimumBytes 2GB

# Remove the default network adapter
Remove-VMNetworkAdapter -VMName "pfsense" -Name "Network Adapter"

# Add first network adapter and connect it to ExternalSwitch
Add-VMNetworkAdapter -VMName "pfsense" -SwitchName "ExternalSwitch"

# Add second network adapter and connect it to NatSwitch
Add-VMNetworkAdapter -VMName "pfsense" -SwitchName "NatSwitch"

# Add DVD drive to the VM and mount the ISO
Add-VMDvdDrive -VMName "pfsense" -ControllerNumber 0 -ControllerLocation 1 -Path $centosIsoPath

# Generation 1 VMs boot from the DVD by default if present
Write-Host "pfSense VM has been created with the ISO mounted and two network adapters attached."
