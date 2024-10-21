Diese Dokumentation erklärt Schritt-für-Schritt wie man eine Linux Testumgebung in Windows mittels Hyper-V erstellt.

- Betriebssysteme:
    - Hypervisor: Windows 11 Hyper-V
    - Linux VMs = RedHat und Debian Distros
    - Windows VMs = Windows Server 2016 und Windows 10

- Software-Lösungen (Open-Source):
    - Firewall: pfSense
    - IDE: Security Onion
    - Automatisierung: Kickstart/Preseed/AutoInstall, Ansible
    - Sicherheitsüberwachungs- und Log-Management: Wazuh
    - Schwachstellen-Management: Greenbone
    - Netzwerk-Boot-Technologie: PXE

Bestimmte Bereiche gehen auf Automatisierung ein um die Bereitstellung zu vereinfachen:
- Powershell Skripte fürs Erstellen von Ordnerstukturen, virtuellen Switche, VM-Profile
- PXE (Preboot eXecution Environment) als Netzwerk-Boot-Technologie
- Kickstart-, Preseed- und AutoInstall-Dateien, um Standard-Betriebssystem-ISOs mit benutzerdefinierten Einstellungen anzupassen
- Ansible Playbooks für eine zentrale Konfigurationsverwaltung
