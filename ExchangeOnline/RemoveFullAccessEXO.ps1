#Remove permissions to mailbox from CSV
#Create CSV first
#Please execute connect-exchangeonline first
#Please set the $csvPath variable
#Twan Verdel
#Vragen? Twan Verdel

$user = Read-Host "Enter the user to remove access from shared mailboxes"
$csvPath = ''
$UPNs = Import-Csv -Path $csvPath

Connect-ExchangeOnline

try {
foreach ($UPN in $UPNs){
    $removeUPN = $UPN.UPN
    Remove-MailboxPermission -Identity $removeUPN -User $user -AccessRights FullAccess
    Write-Host "Full access permission removed for user '$user' to '$removeUPN'"
    }
} catch{
    Write-Host "An error occurred while removing permission for user"
}