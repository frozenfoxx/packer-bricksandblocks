# windows-net-dns.ps1

param (
  [string]$DnsPrimary,
  [string]$DnsSecondary
)

# Get the first Ethernet interface name
$interfaceName = Get-NetAdapter | Where-Object { $_.InterfaceDescription -like "*Ethernet*" } | Select-Object -ExpandProperty Name -First 1

# Check if an interface was found
if ($interfaceName) {
  Write-Output "Interface: $interfaceName"
  
  # Set the DNS hosts
  Write-Output "Setting DNS to $DnsPrimary,$DnsSecondary..."
  Set-DnsClientServerAddress -InterfaceAlias $interfaceName -ServerAddresses $DnsPrimary,$DnsSecondary
} else {
  Write-Output "No Ethernet interface found."
}