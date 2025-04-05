# windows-net-static_ip.ps1

param (
  [string]$IpAddress = "192.168.201.253",
  [int]$PrefixLength = 24,
  [string]$DefaultGateway = "192.168.201.1"
)

# Get the first Ethernet interface
$interface = Get-NetAdapter | Where-Object { $_.InterfaceDescription -like "*Ethernet*" } | Select-Object -First 1

# Check if an interface was found
if ($interface) {
  # Get the InterfaceAlias
  $interfaceAlias = $interface.Name
  
  Write-Output "Interface: $interfaceAlias"

  # Disable DHCP
  Write-Output "Disabling DHCP..."
  try {
    Set-NetIPInterface -InterfaceAlias $interfaceAlias -Dhcp Disabled -ErrorAction Stop
  } catch {
    Write-Output "Error disabling DHCP: $($Error[0].Message)"
  }

  # Remove any existing IP addresses
  Write-Output "Removing existing IP addresses..."
  try {
    Remove-NetIPAddress -InterfaceAlias $interfaceAlias -Confirm:$false -ErrorAction Stop
  } catch {
    Write-Output "Error removing existing IP addresses: $($Error[0].Message)"
  }

  # Set the static IP address
  Write-Output "Setting the following IP information:"
  Write-Output "IP: $IpAddress"
  Write-Output "PrefixLength: $PrefixLength"
  Write-Output "Default Gateway: $DefaultGateway"

  try {
    New-NetIPAddress -InterfaceAlias $interfaceAlias -IPAddress $IpAddress -PrefixLength $PrefixLength -DefaultGateway $DefaultGateway -ErrorAction Stop
  } catch {
    Write-Output "Error setting static IP address: $($Error[0].Message)"
    Start-Sleep -s 3600
  }
} else {
  Write-Output "No Ethernet interface found."
}
