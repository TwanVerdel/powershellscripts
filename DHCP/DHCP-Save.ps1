$DhcpServer = Read-Host "DHCPserver?"

$scopes = Get-DhcpServerv4Scope -ComputerName $DhcpServer


foreach ( $scope in $scopes ) {

get-DhcpServerv4Lease -ComputerName $DhcpServer -ScopeId $scope.ScopeId.IPAddressToString | format-table -AutoSize #| where  { $_.ClientId -like "" } # | where  { $_.ScopeId -like "*" }  


}

