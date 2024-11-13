Diese Dokumentation erklärt Schritt-für-Schritt wie man eine Linux Testumgebung in Windows mittels Hyper-V aufbaut.

# Voraussetzungen

## Hardware

* Prozessor: 8 Kerne / 16 logische Prozessoren (Intel i9 or AMD Ryzen 7)
* RAM: 32GB+
* SSD: 120GB+

## VM Namen und Ressourcen

| VM Name       | CPU | RAM   | HDD       | Memory Type |
|---------------|-----|-------|-----------|-------------|
| 0. pfsense    | 1   | 2 GB  | 60 GB     | Dynamisch   |
| 1. centos     | 2   | 4 GB  | 60 GB     | Dynamisch   |
| 2. ubuntu     | 2   | 4 GB  | 60 GB     | Dynamisch   |
| 3. fedora     | 1   | 2 GB  | 60 GB     | Dynamisch   |
| 4. debian     | 1   | 2 GB  | 60 GB     | Dynamisch   |
| 5. kali       | 2   | 2 GB  | 60 GB     | Dynamisch   |

Gesamtverbrauch ohne Software:
* 9 CPU Kerne (von 16 Kernen)
* 16 GB RAM (von 32 GB)
* ~ 60GB HDD (von 1 TB)

## Software

* Betriebssystem: Windows 11
* Hypervisor: Hyper-V

Folgende Kommandos in Terminal bzw PowerShell als Admin ausführen:

Passende PowerShell Execution Policy setzen, um das Ausführen lokaler Skripte zuzulassen:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```
> RemoteSigned: Erlaubt das Ausführen von lokal erstellten Skripten ohne Einschränkungen. Skripte, die aus dem Internet heruntergeladen werden, müssen jedoch von einem vertrauenswürdigen Herausgeber signiert sein.

Hyper-V Features installieren:

```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
```

Git für Windows installieren:

```powershell
winget install --id Git.Git -e --source winget
```

# Git übernehmen

Um das Repository `https://github.com/luki4no/lab.git` in dein eigenes GitHub-Konto zu klonen, kannst du entweder das Repository **forken** (empfohlen) oder manuell kopieren und in ein neues Repository pushen. Hier ist die aktualisierte Anleitung:

### Methode 1: Forken (Empfohlen)
1. **Öffne das Repository** auf GitHub: [https://github.com/luki4no/lab](https://github.com/luki4no/lab).
2. Klicke oben rechts auf die Schaltfläche **Fork**.
3. GitHub erstellt nun eine Kopie des Repositorys in deinem eigenen Konto.

Das Forken erstellt eine Kopie des Repositorys in deinem Konto und behält die Verbindung zum Original-Repository bei, was spätere Updates und Pull Requests erleichtert.

### Methode 2: Manuelles Klonen und Pushen
Falls du das Repository ohne eine direkte Verbindung zum Original kopieren möchtest, folge diesen Schritten:

1. **Klonen des Repositorys lokal**:
   ```bash
   git clone https://github.com/luki4no/lab.git C:\lab
   ```

2. **Neues Repository auf GitHub erstellen**:
   - Gehe zu deinem GitHub-Profil und erstelle ein neues Repository (z. B. `lab-copy`).

3. **Das neue Repository als Remote hinzufügen und pushen**:
   Gehe im geklonten Ordner `C:\lab` folgendermaßen vor:
   ```bash
   cd C:\lab
   git remote remove origin  # Entferne das alte Remote
   git remote add origin https://github.com/deinusername/lab-copy.git
   git push -u origin main  # Push in dein neues Repository
   ```

Nun befindet sich das Repository in deinem GitHub-Konto und ist vom Original unabhängig, es sei denn, du wählst eine Verknüpfung für spätere Änderungen.

# git clone Struktur:
```powershell
tree /F
```
```plaintext
PS C:\lab> tree /F
Folder PATH listing for volume Windows
Volume serial number is AC7C-AA26
C:.
│   0. README.md
│   1. Umgebung.md
│   2. Virtuelle Switches (Hyper-V).md
│   3. Firewall implementieren (pfSense).md
│   4. OpenVPN Server implementieren (pfSense).md
│   5. Automatisierung mit Ansible.md
│
└───vm
    ├───automation
    │       ansible-pfsense-config.yml
    │       kickstart-centos-bios-mbr
    │       kickstart-fedora-server-bios-mbr
    │       kickstart-fedora-server-efi-gpt
    │       preseed-debian-efi-gpt
    │
    ├───backup
    │       config-pfSense.home.arpa-20241106170305.xml
    │       pfSense-UDP4-1194-lucian-config.ovpn
    │       tftpboot-structure.tar.gz
    │       tftpboot_backup.tar.gz
    │       
    ├───hdds
    │       debian.vhdx
    │       debian_10619A2F-5C19-466A-981F-93492645DFB8.avhdx
    │       fedora.vhdx
    │       fedora_A11B829E-57CD-43BD-85EA-4FCE27FA969D.avhdx
    │       kali.vhdx
    │       kali_3867AF9C-86B3-4E42-946F-7A4352AF3E30.avhdx
    │       kali_C8431747-933C-464D-81DC-08CC87D0A938.avhdx
    │       kali_D1E79693-C4CB-4901-B0D3-6FFB175D30D1.avhdx
    │       ubuntu.vhdx
    │       ubuntu_8DD98A3F-30A9-43F3-ACA9-1DA0BFA34635.avhdx
    │
    ├───iso-images
    │       2022-07-01-raspios-bullseye-i386.iso
    │       CentOS-Stream-9-latest-x86_64-boot.iso
    │       CentOS-Stream-9-latest-x86_64-dvd1.iso
    │       debian-12.7.0-amd64-DVD-1.iso
    │       debian-12.7.0-amd64-netinst.iso
    │       Fedora-Everything-netinst-x86_64-40-1.14.iso
    │       Fedora-Server-dvd-x86_64-41-1.4.iso
    │       Fedora-Workstation-Live-x86_64-40-1.14.iso
    │       kali-linux-2024.2-installer-amd64.iso
    │       kali-linux-2024.3-installer-netinst-amd64.iso
    │       pfSense-CE-2.7.2-RELEASE-amd64
    │       pfSense-CE-2.7.2-RELEASE-amd64.iso
    │       securityonion-2.4.110-20241010.iso
    │       ubuntu-24.04.1-desktop-amd64.iso
    │       ubuntu-24.04.1-live-server-amd64.iso      
    │       
    ├───ps-scripts
    │       create-centos-vm.ps1
    │       create-debian-vm.ps1
    │       create-fedora-vm.ps1
    │       create-folders.ps1
    │       create-internal-external-private-switches.ps1
    │       create-kali-vm.ps1
    │       create-pfsense-vm.ps1
    │       create-ubuntu-vm.ps1
    │       download-iso.ps1
    │       remove-internal-external-private-switches.ps1
    │
    └───pxe
        │   default
        │   grub.cfg
        │   ldlinux.c32
        │   libcom32.c32
        │   libutil.c32
        │   menu.c32
        │   pxelinux.0
        │   Standard locations.txt
        │   vesamenu.c32
        │
        ├───centos
        │       initrd.img
        │       vmlinuz
        │
        ├───debian
        │       initrd.gz
        │       vmlinuz
        │
        ├───fedora
        │       initrd.img
        │       vmlinuz
        │
        ├───kali
        │       initrd.gz
        │       vmlinuz
        │
        └───ubuntu
                initrd
                vmlinuz

PS C:\lab>
```
