# Define folder paths
$folders = @(
    "C:\lab\vm\",
    "C:\lab\vm\hdds\",
    "C:\lab\vm\iso-images\",
    "C:\lab\vm\ps-scripts\",
    "C:\lab\vm\automation\"
)

# Create each folder if it doesn't already exist
foreach ($folder in $folders) {
    if (-not (Test-Path -Path $folder)) {
        New-Item -Path $folder -ItemType Directory
        Write-Host "Created folder: $folder"
    } else {
        Write-Host "Folder already exists: $folder"
    }
}
