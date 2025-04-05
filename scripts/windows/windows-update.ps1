# Variables

$excludedUpdatesFile = "F:\windows-update_exclusion.txt" # Define the path to the file of excluded updates

# Functions

## Check if the system needs to be rebooted
function Confirm-Reboot {
  $rebootRequired = Get-WindowsUpdate | Where-Object { $_.RestartRequired -eq $true }

  # If a reboot is required, restart the computer
  if ($rebootRequired) {
    Write-Host "Reboot required, restarting computer ..."
    Restart-Computer -Confirm:$false -Force
  } else {
    Write-Host "No reboot required"
  }
}

## Hide updates we are not interested in
function Hide-Updates {
  $excludedUpdates = Get-Content -Path $excludedUpdatesFile

  Write-Host "Hiding excluded updates in $excludedUpdatesFile ..."
  foreach ($update in $excludedUpdates) {
    Get-WindowsUpdate -KBArticleID $update -Hide -Verbose
  }
}

## Install required providers and modules
function Install-Providers {
  Write-Host "Installing required providers and modules ..."

  Install-PackageProvider -Name NuGet -Force
  Set-PSRepository PSGallery -InstallationPolicy Trusted
  Install-Module -Name PSWindowsUpdate -Force
  Import-Module -Name PSWindowsUpdate
}

## Install updates
function Install-Updates {
  foreach ($update in $updatesToInstall) {
    Write-Host "Installing update $($update.KBArticleID)"
    Install-WindowsUpdate -KBArticleID $update.KBArticleID -AcceptAll -Verbose
  }
}

# Logic

Install-Providers

## Get the list of available updates
$updatesToInstall = Get-WindowsUpdate

Hide-Updates
Install-Updates
Confirm-Reboot
