# Populate your User variable
$Users = Get-Aduser -Filter * -Properties nTSecurityDescriptor, Name

#StartLoop1: Check for disabled security inheritance
ForEach ($User in $Users) { 
    #Here's the check
    If ($user.nTSecuirtyDescrioptor.AreAccessRulesProtected -eq $False) {
        Write-Host "User: $($User.Name) has inheritance disabled "
    } 
} #EndLoop1