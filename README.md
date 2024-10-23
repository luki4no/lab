Diese Dokumentation erklärt Schritt-für-Schritt wie man eine Linux Testumgebung in Windows mittels Hyper-V erstellt.

## Voraussetzungen

Windows mit Hyper-V:

```powershell
PS > Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
```

Optional: Git, um die Repo herunterzuladen:

```powershell
PS > winget install --id Git.Git -e --source winget
```

Git Repository-Download:

```powershell
PS > git clone https://github.com/luki4no/lab.git 
```
