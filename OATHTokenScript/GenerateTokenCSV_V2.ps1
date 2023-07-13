#Select path:
cd "$env:userprofile\OATHTokenScript\TokenImport"

####################################################
############### Starting Excel #####################
####################################################
# Reset the override choice for each iteration

$overrideChoice = ""
$Excel = New-Object -ComObject Excel.Application
$Excel.Visible = $true
$Excel.DisplayAlerts = $false

# Open an existing workbook on your hard drive
$Workbook = $Excel.Workbooks.Open("$env:userprofile\\OATHTokenScript\Tokens.xlsx")

####################################################
########### Working with Worksheets ################
####################################################

# Select the "Werkblad serienr+upn" sheet (Sheet 2)
$Sheet2 = $Workbook.Sheets.Item("")

# Ask the user for inputs
$tokenSerialNumberInput = Read-Host "Enter Token Serial Number(s) (separated by commas)"
$userUPNInput = Read-Host "Enter User UPN(s) (separated by commas)"
$commentInput = Read-Host "Enter Comment(s) (optional, separated by commas)"

$tokenSerialNumbers = $tokenSerialNumberInput -split ',' | ForEach-Object { $_.Trim() }
$userUPNs = $userUPNInput -split ',' | ForEach-Object { $_.Trim() }
$comments = $commentInput -split ',' | ForEach-Object { $_.Trim() }

# Select sheet 1 (token_masterfile)
$Sheet1 = $Workbook.Sheets.Item("")

# Find the row with the corresponding serial number in sheet 1
$date = Get-Date -UFormat "%d-%m-%Y"

# Create an array to store the data for CSV export
$csvData = @()

# Loop over the arrays of serial numbers, UPNs, and comments
for ($i = 0; $i -lt $tokenSerialNumbers.Count; $i++) {
    $tokenSerialNumber = $tokenSerialNumbers[$i]
    $userUPN = $userUPNs[$i]
    $comment = $comments[$i]

        
    # Find the row with the corresponding serial number in sheet 2
    $existingRow = $Sheet2.UsedRange.Rows | Where-Object { $_.Cells.Item(1).Value2 -eq $tokenSerialNumber }

    if ($existingRow) {
        # Serial number already exists
        if ($overrideChoice -ne "A") {
            # Ask for override choice if not "Yes to all"
            $overrideUPN = Read-Host "Serial number: $tokenSerialNumber already exists in file. Do you want to override the UPN? (Y/N/A for Yes to all)"
            if ($overrideUPN -eq "A") {
                $overrideChoice = "A"
            }
        }

        if ($overrideChoice -eq "A" -or $overrideUPN -eq "Y") {
            # Override the UPN of the existing row
            $existingRow.Cells.Item(2).Value2 = $userUPN
        }
    }
    else {
        # Serial number doesn't exist, find the first empty row and add the values
        $emptyRow = $Sheet2.UsedRange.Rows.Count + 1
        $Sheet2.Cells.Item($emptyRow, 1).Value2 = $tokenSerialNumber
        $Sheet2.Cells.Item($emptyRow, 2).Value2 = $userUPN
        $existingRow = $Sheet2.Rows.Item($emptyRow)
    }

    # Find the row with the corresponding serial number in sheet 1
    $foundRow = $Sheet1.UsedRange.Rows | Where-Object { $_.Cells.Item(2).Value2 -eq $tokenSerialNumber }

    if ($foundRow) {
        # Set the value in column G to the current date
        $foundRow.Cells.Item(7).Value2 = $date

        # Set the comment if provided
        if (![string]::IsNullOrEmpty($comment)) {
            $foundRow.Cells.Item(11).Value2 = $comment
        }
    }

    # Add data to the CSV array
    $csvData += [PSCustomObject]@{
        'upn'           = $Sheet1.Cells.Item($foundRow.Row, 1).Value2
        'serial number' = $Sheet1.Cells.Item($foundRow.Row, 2).Value2
        'secret key'    = $Sheet1.Cells.Item($foundRow.Row, 3).Value2
        'time interval' = $Sheet1.Cells.Item($foundRow.Row, 4).Value2
        'manufacturer'  = $Sheet1.Cells.Item($foundRow.Row, 5).Value2
        'model'         = $Sheet1.Cells.Item($foundRow.Row, 6).Value2
    }
}

####################################################
########## Creating CSV with Column A - F ##########
####################################################

# Create a CSV file using Export-Csv
$csvData | Select-Object -Property * -ExcludeProperty PSObject, PSShowComputerName | ConvertTo-Csv -NoTypeInformation | ForEach-Object { $_ -replace '"', '' } | Out-File -Encoding UTF8 -FilePath "TokenImport-$date.csv"

####################################################
########## Cleaning up the environment #############
####################################################

Write-Host "Saving the Excel workbook"
$Excel.Workbooks.item("Tokens.xlsx").Save()
Write-Host "Closing Excel"
$Workbook.Close($true)
$Excel.Quit()

# Release the COM objects
Write-Host "Cleaning up the environment"
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($Sheet1) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($Sheet2) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($Workbook) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($Excel) | Out-Null
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()

# Check if an Excel process still exists after quitting
# Remove the Excel process by piping it to Stop-Process
Get-Process excel | Stop-Process -Force