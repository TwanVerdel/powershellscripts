#Get user UPN's and exports to csv to prepare for migration batch
#Twan Verdel

# Prompt for display names (separated by commas)
$displayNames = Read-Host "Enter the display names (separated by commas):"
$displayNamesArray = $displayNames -split ',' | ForEach-Object { $_.Trim() }
$path = "<path>"
# Initialize an array to store the results
$results = @()

# Retrieve the UPN for each user
foreach ($displayName in $displayNamesArray) {
    try {
        $users = Get-ADUser -Filter "Name -like '$displayName*'" -Properties UserPrincipalName

        if ($users.Count -eq 0) {
            Write-Host "User '$displayName' not found in Active Directory."
        } elseif ($users.Count -gt 1) {
            Write-Host "Multiple users found for '$displayName':"

            # Display the multiple users and prompt for selection
            $index = 1
            $users | ForEach-Object {
                Write-Host "$index. $($_.UserPrincipalName)"
                $index++
            }

            Write-Host "$index. Get UPN for all users"
            $selection = Read-Host "Select the user by number or enter '$index' to get UPN for all users:"

            if ($selection -eq $index) {
                # Retrieve UPNs for all users
                foreach ($user in $users) {
                    $result = [PSCustomObject]@{
                        DisplayName = $displayName
                        UPN = $user.UserPrincipalName
                    }
                    $results += $result
                }
            } else {
                $selectedUser = $users[$selection - 1]
                $result = [PSCustomObject]@{
                    UPN = $selectedUser.UserPrincipalName
                }
                $results += $result
            }
        } else {
            $upn = $users.UserPrincipalName
            $result = [PSCustomObject]@{
                DisplayName = $displayName
                UPN = $upn
            }
            $results += $result
        }
    } catch {
        Write-Host "An error occurred while retrieving the UPN for '$displayName': $_"
    }
}

# Save the results to a text file
$results | Export-Csv -Path "$path\UPN_results.csv" -NoTypeInformation

Write-Host "UPN retrieval completed. Results saved to UPN_results.csv."
