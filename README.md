Diese Dokumentation erklärt Schritt-für-Schritt wie man eine Linux Testumgebung in Windows mittels Hyper-V erstellt.

Bestimmte Bereiche gehen auf Automatisierung ein um die Bereitstellung zu vereinfachen. Benutze Technologien:
- Powershell Skripte fürs Erstellen von Ordnerstukturen, virtuellen Switche, VM-Profile
- Kickstart-, Preseed- und AutoInstall-Dateien, um Standard-Betriebssystem-ISOs mit benutzerdefinierten Einstellungen anzupassen
- Ansible Playbooks für eine zentrale Konfigurationsverwaltung
