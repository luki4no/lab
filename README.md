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

# Schritte

## Powershell Skripte zulassen

Du musst in der Regel die **Execution Policy** in Windows 11 anpassen, um deine eigenen PowerShell-Skripte ausführen zu können, da die Standardrichtlinie dies möglicherweise einschränkt.

### 1. **Was ist die Execution Policy?**
Die PowerShell **Execution Policy** legt fest, ob und wie Skripte ausgeführt werden können. Die häufigsten Richtlinien sind:
- **Restricted**: Keine Skriptausführung erlaubt (Standard auf manchen Systemen).
- **RemoteSigned**: Lokale Skripte können ausgeführt werden, aber heruntergeladene Skripte müssen von einem vertrauenswürdigen Herausgeber signiert sein.
- **Unrestricted**: Alle Skripte können ausgeführt werden, es wird jedoch eine Warnung angezeigt, wenn Skripte aus dem Internet heruntergeladen wurden.

### 2. **Aktuelle Richtlinie überprüfen**
Um die aktuelle Richtlinie anzuzeigen, führe folgenden Befehl in PowerShell aus:
```powershell
Get-ExecutionPolicy
```

### 3. **Richtlinie anpassen**
Wenn die Richtlinie **Restricted** ist, musst du sie auf **RemoteSigned** oder eine weniger restriktive Option ändern.

#### Für den aktuellen Benutzer festlegen:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### Für das gesamte System festlegen (Administratorrechte erforderlich):
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
```

### 4. **Temporäre Richtlinie für eine Sitzung**
Falls du die Richtlinie nicht dauerhaft ändern möchtest, kannst du sie für eine einzelne Sitzung umgehen, indem du PowerShell mit folgendem Befehl startest:
```powershell
powershell.exe -ExecutionPolicy Bypass
```

### 5. **Sicherheits-Hinweise**
- Verwende **RemoteSigned**, um lokale Skripte und signierte Skripte aus externen Quellen auszuführen.
- Vermeide **Unrestricted**, insbesondere wenn du Skripte aus unbekannten oder unzuverlässigen Quellen ausführst.
- Überprüfe und teste Skripte immer, bevor du sie ausführst, um deren Sicherheit zu gewährleisten.

Mit diesen Anpassungen kannst du deine eigenen Skripte sicher ausführen.


## Hyper-V Features installieren

```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
```

Git für Windows installieren:

```powershell
winget install --id Git.Git -e --source winget
```

## Git Repository herunterladen

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

