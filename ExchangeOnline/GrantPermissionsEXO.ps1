#Grant permissions to mailbox from CSV
#Please run UPNExport.ps1 first
#Please execute connect-exchangeonline first
#Please set the $csvPath variable
#Twan Verdel

$identity = Read-Host "Enter the shared mailbox to grant access to"
$csvPath = '<path>\UPN_results.csv'
$UPNs = Import-Csv -Path $csvPath

#Connect-ExchangeOnline

try {
foreach ($UPN in $UPNs){
    $grantUser = $UPN.UPN
    Set-Mailbox -Identity $identity -GrantSendonBehalfTo @{Add="$grantUser"}
    Write-Host "GrantSendOnBehalfTo permission set for user '$identity' to '$grantUser'"
    Add-MailboxPermission -Identity $identity -User $grantUser -AccessRights FullAccess
    Write-Host "Full access permission set for user '$identity' to '$grantUser'"
    }
} catch{
    Write-Host "An error occurred while setting GrantSendOnBehalfTo permission for user"
}

Set-Mailbox -Identity $identity -type Shared
Set-Mailbox -Identity $identity -MessageCopyForSendOnBehalfEnabled $True	
