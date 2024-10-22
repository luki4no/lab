# Define folder paths
$folders = @(
    "C:\vm\",
    "C:\vm\hdds\",
    "C:\vm\iso-images\",
    "C:\vm\ps-scripts\",
    "C:\vm\webserver\"
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
