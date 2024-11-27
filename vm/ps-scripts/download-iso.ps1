# Display an info banner about the default download location
Write-Host "=============================================="
Write-Host " Default download location: C:\lab\vm\iso-images\ "
Write-Host " You can change this location when prompted."
Write-Host "=============================================="

# Prompt 1: Ask the user which ISO image they want to download
$isoOption = @"
Please select which ISO image you want to download:
1. RedHat - CentOS (Stream-9) - Full
2. Debian - Ubuntu (24.04.1) - Live
3. RedHat - Fedora (41-1.4) - Server
4. Debian - Debian (12.8.0) - NetInstaller
5. Debian - Kali (2024.3) - NetInstaller
6. Download all sequentially
"@

Write-Host $isoOption
$selection = Read-Host "Enter the number of your choice (1-6)"

# Define the URLs and file names for each ISO
$isoUrls = @(
    @{
        Name = "RedHat - CentOS (Stream-9) - Full"
        Url = "https://mirrors.centos.org/mirrorlist?path=/9-stream/BaseOS/x86_64/iso/CentOS-Stream-9-latest-x86_64-dvd1.iso&redirect=1&protocol=https"
        File = "CentOS-Stream-9-latest-x86_64-dvd1.iso"
    },
    @{
        Name = "Debian - Ubuntu (24.04.1) - Live"
        Url = "https://releases.ubuntu.com/24.04.1/ubuntu-24.04.1-live-server-amd64.iso"
        File = "ubuntu-24.04.1-live-server-amd64.iso"
    },
    @{
        Name = "RedHat - Fedora (41-1.4) - Server"
        Url = "https://download.fedoraproject.org/pub/fedora/linux/releases/41/Server/x86_64/iso/Fedora-Server-dvd-x86_64-41-1.4.iso"
        File = "Fedora-Server-dvd-x86_64-41-1.4.iso"
    },
    @{
        Name = "Debian - Debian (12.8.0) - NetInstaller"
        Url = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.8.0-amd64-netinst.iso"
        File = "debian-12.8.0-amd64-netinst.iso"
    },
    @{
        Name = "Debian - Kali (2024.3) - NetInstaller"
        Url = "https://cdimage.kali.org/kali-2024.3/kali-linux-2024.3-installer-netinst-amd64.iso"
        File = "kali-linux-2024.3-installer-netinst-amd64.iso"
    }
)

# Define the default directory
$defaultDir = "C:\lab\vm\iso-images"

if ($selection -eq "6") {
    # Prompt 2: Ask the user where they want to save all ISO images
    $isoDir = Read-Host "Enter the directory where you want to save the ISOs (Default: $defaultDir)" 
    if (-not $isoDir) { $isoDir = $defaultDir }
    if (-Not (Test-Path $isoDir)) {
        Write-Host "Directory does not exist. Creating it..."
        New-Item -ItemType Directory -Path $isoDir
    }

    # Download all ISOs sequentially
    foreach ($iso in $isoUrls) {
        $isoFilePath = Join-Path $isoDir $iso.File

        if (-Not (Test-Path $isoFilePath)) {
            Write-Host "Downloading $($iso.Name) ISO using Start-BitsTransfer..."
            Start-BitsTransfer -Source $iso.Url -Destination $isoFilePath
            Write-Host "$($iso.Name) ISO downloaded to $isoFilePath."
        } else {
            Write-Host "$($iso.Name) ISO already exists at $isoFilePath."
        }
    }
} elseif ($isoUrls[$selection - 1]) {
    # Single ISO selection
    $selectedIso = $isoUrls[$selection - 1]

    # Prompt 2: Ask the user where they want to save the selected ISO
    $isoDir = Read-Host "Enter the directory where you want to save the ISO (Default: $defaultDir)"
    if (-not $isoDir) { $isoDir = $defaultDir }
    if (-Not (Test-Path $isoDir)) {
        Write-Host "Directory does not exist. Creating it..."
        New-Item -ItemType Directory -Path $isoDir
    }

    # Define the full path to the ISO file
    $isoFilePath = Join-Path $isoDir $selectedIso.File

    # Check if the ISO already exists, and if not, download it
    if (-Not (Test-Path $isoFilePath)) {
        Write-Host "Downloading $($selectedIso.Name) ISO using Start-BitsTransfer..."
        Start-BitsTransfer -Source $selectedIso.Url -Destination $isoFilePath
        Write-Host "$($selectedIso.Name) ISO downloaded to $isoFilePath."
    } else {
        Write-Host "$($selectedIso.Name) ISO already exists at $isoFilePath."
    }
} else {
    Write-Host "Invalid selection. Exiting..."
    exit
}
