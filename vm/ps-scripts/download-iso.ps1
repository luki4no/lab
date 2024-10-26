# Prompt 1: Ask the user which ISO image they want to download
$isoOption = @"
Please select which ISO image you want to download:
1. RedHat - CentOS (Stream-9) - Full
2. RedHat - Fedora (40-1.14) - NetInstaller
3. Debian - Debian (12.7.0) - NetInstaller
4. Debian - Kali (2024.3) - NetInstaller
5. Debian - Ubuntu (24.04.1) - Live
"@

Write-Host $isoOption
$selection = Read-Host "Enter the number of your choice (1-5)"

# Define the URLs and file names for each ISO
$isoUrls = @{
    "1" = @{
        Name = "RedHat - CentOS (Stream-9) - Full"
        Url = "https://mirrors.centos.org/mirrorlist?path=/9-stream/BaseOS/x86_64/iso/CentOS-Stream-9-latest-x86_64-dvd1.iso&redirect=1&protocol=https"
        File = "CentOS-Stream-9-latest-x86_64-dvd1.iso"
    }
    "2" = @{
        Name = "RedHat - Fedora (40-1.14) - NetInstaller"
        Url = "https://download.fedoraproject.org/pub/fedora/linux/releases/40/Everything/x86_64/iso/Fedora-Everything-netinst-x86_64-40-1.14.iso"
        File = "Fedora-Everything-netinst-x86_64-40-1.14.iso"
    }
    "3" = @{
        Name = "Debian - Debian (12.7.0) - NetInstaller"
        Url = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.7.0-amd64-netinst.iso"
        File = "debian-12.7.0-amd64-DVD-1.iso"
    }
    "4" = @{
        Name = "Debian - Kali (2024.3) - NetInstaller"
        Url = "https://cdimage.kali.org/kali-2024.3/kali-linux-2024.3-installer-netinst-amd64.iso"
        File = "kali-linux-2024.2-installer-amd64.iso"
    }
    "5" = @{
        Name = "Debian - Ubuntu (24.04.1) - Live"
        Url = "https://releases.ubuntu.com/24.04.1/ubuntu-24.04.1-live-server-amd64.iso"
        File = "ubuntu-24.04.1-live-server-amd64.iso"
    }
}

if (-Not $isoUrls.ContainsKey($selection)) {
    Write-Host "Invalid selection. Exiting..."
    exit
}

# Store the selected ISO info
$selectedIso = $isoUrls[$selection]

# Prompt 2: Ask the user where they want to save the ISO image
$isoDir = Read-Host "Enter the directory where you want to save the ISO (e.g., C:\lab\vm\iso-images\)"
if (-Not (Test-Path $isoDir)) {
    Write-Host "Directory does not exist. Creating it..."
    New-Item -ItemType Directory -Path $isoDir
}

# Define the full path to the ISO file
$isoFilePath = Join-Path $isoDir $selectedIso.File

# Check if the ISO already exists, and if not, download it
if (-Not (Test-Path $isoFilePath)) {
    Write-Host "Downloading $($selectedIso.Name) ISO..."
    Invoke-WebRequest -Uri $selectedIso.Url -OutFile $isoFilePath
    Write-Host "$($selectedIso.Name) ISO downloaded to $isoFilePath."
} else {
    Write-Host "$($selectedIso.Name) ISO already exists at $isoFilePath."
}
