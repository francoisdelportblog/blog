if (!([System.Diagnostics.EventLog]::SourceExists('S.M.A.R.T.')))
{
    New-EventLog -LogName 'System' -Source 'S.M.A.R.T.' 
}

$failures = Get-WmiObject -namespace root\wmi –class MSStorageDriver_FailurePredictStatus -ErrorAction SilentlyContinue | Select-Object InstanceName, PredictFailure, Reason | Where-Object -Property PredictFailure -NE $false

foreach($failure in $failures)
{
    Write-EventLog -LogName 'System' -Source 'S.M.A.R.T.' -EntryType Error -EventId 0 -Category 0 -Message "SMART Failure Prediction \r\n $($failure.InstanceName) \r\n $($failure.PredictFailure) \r\n $($failure.Reason)"
}