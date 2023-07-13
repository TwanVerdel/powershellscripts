$groupPrefix = Read-Host -Prompt "Please enter the groupname prefix"

$groups = Get-ADGroup -Filter "Name -like '$groupPrefix*'" | Sort-Object Name

if ($groups) {
    foreach ($group in $groups) {
        $groupName = $group.Name
        $groupMembers = Get-ADGroupMember $groupName | Where-Object {$_.objectClass -eq "user"}
        $userCNs = foreach ($user in $groupMembers) {
            (Get-ADUser $user -Properties CN).CN
        }
        Write-Host "$groupName :"
        if ($userCNs) {
            $userCount = $userCNs.Count
            Write-Host "$userCount users:"
            foreach ($i in 0..($userCount - 1)) {
                Write-Host $userCNs[$i]
                if ($i -lt ($userCount - 1)) {
                    continue
                } else {
                    Write-Host ""
                }
            }
        } else {
            Write-Host "No users in this group"
            Write-Host " "
        }
    }
} else {
    Write-Host "No group found starting with prefix: $groupPrefix"
}
