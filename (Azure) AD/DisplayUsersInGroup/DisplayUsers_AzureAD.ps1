Connect-AzAccount

$groupPrefix = Read-Host -Prompt "Please enter the groupname prefix (AzureAD)"

$groups = Get-AzureADGroup -SearchString "$groupPrefix"

if ($groups) {
    foreach ($group in $groups) {
        $groupName = $group.DisplayName
        $groupObjectId = $group.ObjectId

        $groupMembers = Get-AzureADGroupMember -ObjectId $groupObjectId

        foreach ($user in $groupMembers) {
            $userID = $user.ObjectId
        }
        write-Host "$userID"

        Write-Host "$groupName :"
        if ($userID) {
            $userCount = $userID.Count
            Write-Host "$userCount users:"
            foreach ($i in 0..($userCount - 1)) {
               Write-Host $userIDs[$i]
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
