$group = Read-Host -Prompt "Please insert the groupname"
$group2 = Read-Host -Prompt "Please insert the second groupname"
$count = GET-ADUSER -Filter * –Properties MemberOf | where { $_.MemberOf -like "*$group*" -and $_.MemberOf -like "*$group2*"  } 


