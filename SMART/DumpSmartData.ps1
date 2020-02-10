function WriteDataline($model, $serial, $firmware, $smart_ok, $attr_json) {
    $hostname = $env:computername
    $date = Get-Date -Format 's'
    $attr_line = "$($attr_json.id),$($attr_json.name),$($attr_json.value),$($attr_json.worst),$($attr_json.thresh),$($attr_json.when_failed),$($attr_json.flags.value),$($attr_json.flags.string),$($attr_json.flags.prefailure),$($attr_json.flags.updated_online),$($attr_json.flags.performance),$($attr_json.flags.error_rate),$($attr_json.flags.event_count),$($attr_json.flags.auto_keep),$($attr_json.raw.value),$($attr_json.raw.string)"
    $line = "$hostname,$date,$model,$serial,$firmware,$smart_ok,$attr_line"
    Out-File $logfile -Append -InputObject $line
}

$logdir = 'c:\Logs\'
if (!(Test-Path $logdir)) {
    New-Item $logdir -ItemType Directory
}

$logfile = ($logdir + 'smart.csv')
if (!(Test-Path $logfile)) {
    Out-File $logfile -InputObject 'host,date,model,serial_no,firmware,smart_ok,attr_id,attr_name,attr_value,attr_worst,attr_thresh,attr_when_failed,attr_flags_value,attr_flags_string,attr_flags_prefailure,attr_flags_updated_online,attr_flags_performance,attr_flags_error_rate,attr_flags_event_count,attr_flags_auto_keep,attr_raw_value,attr_raw_string'
}

$toolpath = 'c:\Tools\SmartmonTools\smartctl.exe'

$arguments = ' --scan --json'
$scan_result = Invoke-Expression "$toolpath $arguments" | ConvertFrom-Json

foreach ($device in $scan_result.devices) {
    $arguments = "$($device.name) --json -a"
    $smart_result = Invoke-Expression "$toolpath $arguments" | ConvertFrom-Json

    if ($smart_result.ata_smart_attributes) {
        foreach ($attr in $smart_result.ata_smart_attributes.table) {
            WriteDataline -model $smart_result.model_name -serial $smart_result.serial_number -firmware $smart_result.firmware_version `
                -smart_ok $smart_result.smart_status.passed -attr_json $attr
        }
    }
    else {
        Out-File ($logdir + "Errors.log") "Device does not support SMART or it is not enabled $($device.name)"
    }
}
