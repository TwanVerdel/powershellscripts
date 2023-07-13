$computerName = Read-Host "Computername = ?"
$ExpectedFree = "10"
$Stats = Get-DhcpServerv4ScopeStatistics -ComputerName $computerName

foreach($pool in $stats){
if($pool.Free -lt $ExpectedFree){
$ScopeStatus += "$($Pool.ScopeId) has $($Pool.free) left "
}
}

if(!$ScopeStatus ){ $ScopeStatus  = "Healthy"}

