#!/bin/sh

# Display options to the user
echo "Please select which ISO image you want to download:"
echo "1. RedHat - CentOS (Stream 9)"
echo "2. Debian - Ubuntu Server (24.04.1)"
echo "3. RedHat - Fedora Server (41-1.4)"
echo "4. Debian - Debian (12.8.0)"
echo "5. Debian - Kali (2024.3)"
echo "6. >>> Download All ISOs <<<"
echo "7. Exit"
echo

# Prompt the user for a choice
read -p "Enter the number of your choice (1-7): " selection

# Define ISO details as individual variables
iso_name_1="RedHat - CentOS (Stream 9)"
iso_url_1="https://mirrors.centos.org/mirrorlist?path=/9-stream/BaseOS/x86_64/iso/CentOS-Stream-9-latest-x86_64-dvd1.iso&redirect=1&protocol=https"
iso_file_1="CentOS-Stream-9-latest-x86_64-dvd1.iso"

iso_name_2="Debian - Ubuntu Server (24.04.1)"
iso_url_2="https://releases.ubuntu.com/24.04.1/ubuntu-24.04.1-live-server-amd64.iso"
iso_file_2="ubuntu-24.04.1-live-server-amd64.iso"

iso_name_3="RedHat - Fedora Server (41-1.4)"
iso_url_3="https://download.fedoraproject.org/pub/fedora/linux/releases/41/Server/x86_64/iso/Fedora-Server-dvd-x86_64-41-1.4.iso"
iso_file_3="Fedora-Server-dvd-x86_64-41-1.4.iso"

iso_name_4="Debian - Debian (12.8.0)"
iso_url_4="https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.8.0-amd64-netinst.iso"
iso_file_4="debian-12.8.0-amd64-netinst.iso"

iso_name_5="Debian - Kali (2024.3)"
iso_url_5="https://cdimage.kali.org/kali-2024.3/kali-linux-2024.3-installer-netinst-amd64.iso"
iso_file_5="kali-linux-2024.3-installer-netinst-amd64.iso"

# Set the download directory
iso_dir="/usr/local/www/pxe/iso"

# Create the directory if it doesn't exist
if [ ! -d "$iso_dir" ]; then
    echo "Directory does not exist. Creating it..."
    mkdir -p "$iso_dir"
fi

# Function to download a single ISO
download_iso() {
    name="$1"
    url="$2"
    file="$3"
    iso_file_path="$iso_dir/$file"

    if [ ! -f "$iso_file_path" ]; then
        echo "Downloading $name ISO..."
        curl -L -o "$iso_file_path" "$url"
        echo "$name ISO downloaded to $iso_file_path."
    else
        echo "$name ISO already exists at $iso_file_path."
    fi
}

# Download based on the user's choice
case "$selection" in
    1)
        download_iso "$iso_name_1" "$iso_url_1" "$iso_file_1"
        ;;
    2)
        download_iso "$iso_name_2" "$iso_url_2" "$iso_file_2"
        ;;
    3)
        download_iso "$iso_name_3" "$iso_url_3" "$iso_file_3"
        ;;
    4)
        download_iso "$iso_name_4" "$iso_url_4" "$iso_file_4"
        ;;
    5)
        download_iso "$iso_name_5" "$iso_url_5" "$iso_file_5"
        ;;
    6)
        echo "Downloading all ISOs..."
        download_iso "$iso_name_1" "$iso_url_1" "$iso_file_1"
        download_iso "$iso_name_2" "$iso_url_2" "$iso_file_2"
        download_iso "$iso_name_3" "$iso_url_3" "$iso_file_3"
        download_iso "$iso_name_4" "$iso_url_4" "$iso_file_4"
        download_iso "$iso_name_5" "$iso_url_5" "$iso_file_5"
        echo "All ISOs downloaded."
        ;;
    7)
        echo "Exiting script."
        exit 0
        ;;
    *)
        echo "Invalid selection. Exiting..."
        exit 1
        ;;
esac
