#Get-MigrationEndpoint | Format-List Identity, RemoteServer

#Variables
$migrationEndpointIdentity = "<migrationendpoint>"
$remoteServer = "<server>"

#User prompted
$SharedMailbox = Read-Host -Prompt "Please insert the shared mailbox"
$user = Read-Host -Prompt "Please insert the user"
$mailbox = Read-Host -Prompt "Do you wish to migrate the user or the shared mailbox?"

#Connect EXO
Connect-ExchangeOnline

#Migrate mailbox
if ($mailbox = "user") {
    New-MoveRequest -Identity $user -Remote -RemoteHostName $remoteServer -TargetDeliveryDomain "exoip365.mail.onmicrosoft.com" -RemoteCredential (Get-Credential exoip\administrator)
} elseif ($mailbox = "shared mailbox"){
    New-MoveRequest -Identity $SharedMailbox -Remote -RemoteHostName $remoteServer -TargetDeliveryDomain "exoip365.mail.onmicrosoft.com" -RemoteCredential (Get-Credential exoip\administrator)
} else {
    Write-Host 'Failed to migrate mailbox, please only choose between "user" or "shared mailbox"'
}


#Convert to Shared mailbox
Set-Mailbox $SharedMailbox -Type shared

#Grant Send On Behalf
Set-Mailbox -Identity $SharedMailbox -GrantSendOnBehalfTo $user
Add-MailboxPermission $SharedMailbox -User "$user" -AccessRights FullAccess

#Copy Send On Behalf Message
Set-Mailbox -Identity $SharedMailbox -MessageCopyForSendOnBehalfEnabled $True

#Copy Send As
#Set-Mailbox $mailBox -MessageCopyForSentAsEnabled $true

#Get mailbox permissionns
#Send on behalf
Get-Mailbox $mailbox | select Name,UserPrincipalName,PrimarySmtpAddress,@{l='SendOnBehalfOf';e={$_.GrantSendOnBehalfTo -join ";"}} | Export-CSV "D:\SendOnBehalf.csv"

#Full access
Get-MailboxPermission ethiek@kwadrantgroep.nl | Where { ($_.IsInherited -eq $False) -and ($_.AccessRights -like "*FullAccess*") -and -not ($_.User -like "NT AUTHORITYSELF") } |
Select Identity, User | Export-CSV "D:\FullAccess.csv"

