Import-Module "sqlps" -DisableNameChecking 

Write-Output ('$env:SqlInstanceName : ' + $env:SqlInstanceName)
Write-Output ('$env:DBBackupFolder : ' + $env:DBBackupFolder)
Write-Output ('$env:DBName : ' + $env:DBName)

if( (Test-Path $env:DBBackupFolder) -eq $false )
{
    New-Item -Path $env:DBBackupFolder -ItemType Directory
}

$svr = New-Object 'Microsoft.SqlServer.Management.SMO.Server' $env:SqlInstanceName
$backupdir = $env:DBBackupFolder
$svrinst = $svr.Name
$db = $svr.Databases["$env:DBName"]
$dbname = $db.Name
$date = get-date -format yyyyMMddHHmmss
$backupfile = "$backupdir\$($dbname)_db_$($date).bak"
Backup-SqlDatabase -ServerInstance $svrinst -Database $dbname -BackupFile $backupfile
