[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.ReportViewer.WinForms") 
[System.Reflection.Assembly]::LoadWithPartialName("ReportPOC") 

$rv = New-Object Microsoft.Reporting.WinForms.ReportViewer
$data = New-Object "System.Collections.Generic.List[ReportPOC.ReportData]"

$item1 = New-Object ReportPOC.ReportData
$item1.ServerName = "Server1"
$item1.CPUAvail = "150"
$item1.CPUUsed = "123"

$item2 = New-Object ReportPOC.ReportData
$item2.ServerName = "Server2"
$item2.CPUAvail = "120"
$item2.CPUUsed = "100"

$item3 = New-Object ReportPOC.ReportData
$item3.ServerName = "Server3"
$item3.CPUAvail = "128"
$item3.CPUUsed = "103"

$data.Add($item1)
$data.Add($item2)
$data.Add($item3)

$rep = New-Object Microsoft.Reporting.WinForms.ReportDataSource
$rep.Name = "ReportDS"
$rep.Value = $data
$rv.LocalReport.ReportPath = "C:\MySource\ReportPOC\POC.rdlc";
$rv.LocalReport.DataSources.Add($rep);

try
{
    [byte[]]$bytes = $rv.LocalReport.Render("WORDOPENXML");
}
catch{
    $Error[0].Exception.InnerException.InnerException | out-file "error.txt"
}

$fs = [System.IO.File]::Create("C:\MySource\ReportPOC\POC.docx")
$fs.Write( [byte[]]$bytes, 0,  $bytes.Length);
$fs.Flush()
$fs.Close()