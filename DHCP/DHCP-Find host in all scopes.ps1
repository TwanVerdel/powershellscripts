$DhcpServer = REad-Host "DHCPServer?"

$scopes = Get-DhcpServerv4Scope -ComputerName $DhcpServer


foreach ( $scope in $scopes ) {

get-DhcpServerv4Lease -ComputerName $DhcpServer -ScopeId $scope.ScopeId.IPAddressToString #| Where-Object { $_.clientid -eq "" }  #Select-Object $_.ScopeId.ScopeId # where-object { $_.ScopeId.ScopeId -like "**" } |where where  { $_.ClientId -like "" } # | where  { $_.ScopeId -like "" }  

#get-DhcpServerv4Lease -ComputerName $DhcpServer -ScopeId $scope.ScopeId.IPAddressToString | fl # where-object { $_.ScopeId -like "" } | Export-Csv C:\dhcpexportleases.csv -Append -NoTypeInformation -NoClobber

#Export-DhcpServer -ComputerName $DhcpServer -ScopeId $scopes.ScopeId -File 
#Get-DhcpServerv4Scope -ComputerName $DhcpServer -ScopeId $scope.ScopeId #| Format-Table -AutoSize #| Select-Object option3
#Get-DhcpServerv4Filter -ComputerName $DhcpServer #-ScopeId $scope.ScopeId | fl

#Get-DhcpServerv4OptionValue -ComputerName $DhcpServer -ScopeId $scope.ScopeId

}

