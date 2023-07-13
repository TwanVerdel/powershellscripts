#Get-ChildItem -Path $path -Include "*.exe" -Recurse -ErrorAction SilentlyContinue


Get-ChildItem -Path $path -Include ("*.msi","*.exe") -Recurse -ErrorAction SilentlyContinue |`
foreach{
$Item = $_
$Type = $_.Extension
$Path = $_.FullName
$Folder = $_.PSIsContainer
$Age = $_.CreationTime

$Path | Select-Object `
    @{n="Name";e={$Item}},`
    @{n="Created";e={$Age}},`
    @{n="filePath";e={$Path}},`
    @{n="Extension";e={if($Folder){"Folder"}else{$Type}}}`
    } | Export-Csv C:\export-Results.csv -NoTypeInformation 