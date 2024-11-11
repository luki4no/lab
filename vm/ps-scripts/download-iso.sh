#!/bin/sh

# Display options to the user
echo "Please select which ISO image you want to download:"
echo "1. RedHat - CentOS (Stream-9) - Full"
echo "2. Debian - Ubuntu (24.04.1) - Live"
echo "3. RedHat - Fedora (41-1.4) - Server"
echo "4. Debian - Debian (12.8.0) - NetInstaller"
echo "5. Debian - Kali (2024.3) - NetInstaller"
echo "6. >>> Download All VMs <<<"
echo

# Prompt the user for a choice
read -p "Enter the number of your choice (1-6): " selection

# Define URLs and filenames for each ISO
declare -A isoUrls
isoUrls=(
    ["1"]="RedHat - CentOS (Stream-9) - Full|https://mirrors.centos.org/mirrorlist?path=/9-stream/BaseOS/x86_64/iso/CentOS-Stream-9-latest-x86_64-dvd1.iso&redirect=1&protocol=https|CentOS-Stream-9-latest-x86_64-dvd1.iso"
    ["2"]="Debian - Ubuntu (24.04.1) - Live|https://releases.ubuntu.com/24.04.1/ubuntu-24.04.1-live-server-amd64.iso|ubuntu-24.04.1-live-server-amd64.iso"
    ["3"]="RedHat - Fedora (41-1.4) - Server|https://download.fedoraproject.org/pub/fedora/linux/releases/41/Server/x86_64/iso/Fedora-Server-dvd-x86_64-41-1.4.iso|Fedora-Server-dvd-x86_64-41-1.4.iso"
    ["4"]="Debian - Debian (12.8.0) - NetInstaller|https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.8.0-amd64-netinst.iso|debian-12.8.0-amd64-netinst.iso"
    ["5"]="Debian - Kali (2024.3) - NetInstaller|https://cdimage.kali.org/kali-2024.3/kali-linux-2024.3-installer-netinst-amd64.iso|kali-linux-2024.3-installer-netinst-amd64.iso"
)

# Set the download directory
iso_dir="/usr/local/www/pxe/iso"

# Create the directory if it doesn't exist
if [ ! -d "$iso_dir" ]; then
    echo "Directory does not exist. Creating it..."
    mkdir -p "$iso_dir"
fi

# Function to download a single ISO
download_iso() {
    local name="$1"
    local url="$2"
    local file="$3"
    local iso_file_path="$iso_dir/$file"

    if [ ! -f "$iso_file_path" ]; then
        echo "Downloading $name ISO..."
        curl -L -o "$iso_file_path" "$url"
        echo "$name ISO downloaded to $iso_file_path."
    else
        echo "$name ISO already exists at $iso_file_path."
    fi
}

# Download based on the user's choice
if [ "$selection" -ge 1 ] && [ "$selection" -le 5 ]; then
    IFS='|' read -r name url file <<< "${isoUrls[$selection]}"
    download_iso "$name" "$url" "$file"
elif [ "$selection" -eq 6 ]; then
    echo "Downloading all ISOs..."
    for key in "${!isoUrls[@]}"; do
        IFS='|' read -r name url file <<< "${isoUrls[$key]}"
        download_iso "$name" "$url" "$file"
    done
    echo "All ISOs downloaded."
else
    echo "Invalid selection. Exiting..."
    exit 1
fi
