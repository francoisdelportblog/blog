Import-Module "sqlps" -DisableNameChecking 

Write-Output ('$env:SqlInstanceName : ' + $env:SqlInstanceName)
Write-Output ('$env:DBBackupFolder : ' + $env:DBBackupFolder)
Write-Output ('$env:DBName : ' + $env:DBName)

if( (Test-Path $env:DBBackupFolder) -eq $false )
{
    New-Item -Path $env:DBBackupFolder -ItemType Directory
}

$svr = New-Object 'Microsoft.SqlServer.Management.SMO.Server' $env:SqlInstanceName
$bdir = $env:DBBackupFolder
$svnm = $svr.Name
$db = $svr.Databases["$env:DBName"]
$dbname = $db.Name
$dt = get-date -format yyyyMMddHHmmss
$bfil = "$bdir\$($dbname)_db_$($dt).bak"
Backup-SqlDatabase -ServerInstance $svnm -Database $dbname -BackupFile $bfil
