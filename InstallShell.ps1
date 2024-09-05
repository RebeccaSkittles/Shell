# Define the installation directory
$installDir = "C:\PowerShell"
$moduleUrl = "https://raw.githubusercontent.com/RebeccaSkittles/Shell/main/Shell.psm1" # Replace with actual URL to the Shell.psm1 file

# Check if the directory already exists
if (-Not (Test-Path -Path $installDir)) {
    # Create the PowerShell directory
    New-Item -ItemType Directory -Path $installDir -Force
    Write-Output "Created directory: $installDir"
} else {
    Write-Output "Directory already exists: $installDir"
}

# Download Shell.psm1 from the provided URL
$modulePath = "$installDir\Shell.psm1"
Invoke-WebRequest -Uri $moduleUrl -OutFile $modulePath

# Verify if the download was successful
if (Test-Path -Path $modulePath) {
    Write-Output "Downloaded Shell.psm1 to $modulePath"
} else {
    Write-Output "Failed to download Shell.psm1"
    exit
}

# Add the installation directory to the PSModulePath if not already present
if ($env:PSModulePath -notcontains $installDir) {
    [System.Environment]::SetEnvironmentVariable('PSModulePath', "$env:PSModulePath;$installDir", [System.EnvironmentVariableTarget]::Machine)
    Write-Output "Added $installDir to PSModulePath"
}

# Set up PowerShell profile to auto-import Shell
$profilePath = [System.IO.Path]::Combine($env:USERPROFILE, 'Documents', 'WindowsPowerShell', 'Microsoft.PowerShell_profile.ps1')

# Ensure the profile exists or create it
if (-Not (Test-Path -Path $profilePath)) {
    New-Item -Path $profilePath -ItemType File -Force
    Write-Output "Created PowerShell profile: $profilePath"
}

# Add import command to the PowerShell profile
Add-Content -Path $profilePath -Value "`nImport-Module Shell"

Write-Output "Setup complete. Restart your PowerShell session or run 'Import-Module Shell' to start using the 'shell' command."
