Get-ADDomain | Select-Object InfrastructureMaster, RIDMaster, PDCEmulator

Get-ADForest | Select-Object DomainNamingMaster, SchemaMaster

Get-ADDomainController -Filter * | Select-Object Name, Domain, Forest, OperationMasterRoles | Where-Object {$_.OperationMasterRoles} | Format-Table -AutoSize

Get-ADObject (Get-ADRootDSE).schemaNamingContext -Property objectVersion

#Move roles
$domaincontroller = 
Move-ADDirectoryServerOperationMasterRole -Identity $domaincontroller –OperationMasterRole 0,1,2,3,4
