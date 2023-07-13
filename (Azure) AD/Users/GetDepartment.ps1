$department = Read-Host -Prompt "Please insert the department"
Get-ADUser -Filter "department -eq $department"  -Properties * | select name, UserPrincipalName,samaccountname,displayname 