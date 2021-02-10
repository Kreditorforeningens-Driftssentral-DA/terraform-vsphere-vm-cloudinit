#ps1_sysnative
$adapter = Get-NetAdapter | Where-Object{$_.Status -eq "up"} # Ethernet0
$adapter | New-NetIPAddress -AddressFamily IPv4 -IPAddress ${ADDRESS} -PrefixLength ${NETMASK} -DefaultGateway ${GATEWAY}
$adapter | Set-DnsClientServerAddress -ServerAddresses ${DNS}

