$groupName = Read-Host -Prompt "Please insert the groupname"
$user = Read-Host -Prompt "Please insert the SAM-accountname of the user"

$groupmembership = Get-ADGroupMember $groupName | Where-Object { $_.objectClass -eq "group"}

foreach ( $group in $groupmembership ) {

$finalgroups += Get-ADGroupMember $group | Where-Object { $_.objectClass -eq "group"}

}

$groups = $finalgroups

foreach ($group in $groups) {
    $members = Get-ADGroupMember -Identity $group | Select -ExpandProperty SamAccountName

    If ($members -contains $user) {
        Write-Host "$user is a member of $($group.name)"
    } Else {
        Write-Host "$user is not a member of $($group.name)"
    }
}