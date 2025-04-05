# windows-net-dhcp.ps1

# Get the first Ethernet interface
$interface = Get-NetAdapter | Where-Object { $_.InterfaceDescription -like "*Ethernet*" } | Select-Object -First 1

# Check if an interface was found
if ($interface) {
  # Get the InterfaceAlias
  $interfaceAlias = $interface.Name
  
  Write-Output "Interface: $interfaceAlias"

  # Enable DHCP
  Write-Output "Enabling DHCP..."
  Set-NetIPInterface -InterfaceAlias $interfaceAlias -Dhcp Enabled
} else {
  Write-Output "No Ethernet interface found."
}
