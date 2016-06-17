$exe = '"' +  'C:\Program Files (x86)\Microsoft SQL Server\120\DAC\bin\SqlPackage.exe' + '"'

Write-Output ('$env:DBWorkingFolder: ' + $env:DBWorkingFolder)
Write-Output ('$env:DacPacFileName : ' + $env:DacPacFileName)
Write-Output ('$env:ConnectionString : ' + $env:ConnectionString)

$sf = "$env:DBWorkingFolder\$env:SYSTEM_HOSTTYPE\$env:DacPacFileName"
$op = "$env:DBWorkingFolder\Report.xml"
$cs =('"' + $env:ConnectionString + '"')

$action= "DeployReport"
$param = "/Action:$action /SourceFile:$sf /TargetConnectionString:$cs /OutputPath:$op"
Write-Output "Generate DeployReport"
Write-Output "Args: $param"
Write-Output ("$exe"  + " " + $param)
Start-Process -FilePath "$exe" -ArgumentList $param  -PassThru

$action= "Script"
$op = "$env:DBWorkingFolder\ChangeScript.sql"
$param = "/Action:$action /SourceFile:$sf /TargetConnectionString:$cs /OutputPath:$op"
Write-Output "Generate Change Script"
Write-Output "Args: $param"
Write-Output ("$exe"  + " " + $param)
Start-Process -FilePath "$exe" -ArgumentList $param  -PassThru

$action= "Publish"
$param = "/Action:$action /SourceFile:$sf /TargetConnectionString:$cs"
Write-Output "Publish Changes"
Write-Output "Args: $param"
Write-Output ("$exe"  + " " + $param)
Start-Process -FilePath "$exe" -ArgumentList $param  -PassThru
