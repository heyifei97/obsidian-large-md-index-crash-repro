param(
    [int]$Seconds = 90,
    [int]$IntervalSeconds = 5
)

$ErrorActionPreference = "Stop"

$end = (Get-Date).AddSeconds($Seconds)
while ((Get-Date) -lt $end) {
    $rows = Get-CimInstance Win32_Process -Filter "name = 'Obsidian.exe'" | ForEach-Object {
        $type = "browser"
        if ($_.CommandLine -match "--type=([^\s]+)") {
            $type = $Matches[1]
        }

        [pscustomobject]@{
            Time = (Get-Date).ToString("HH:mm:ss")
            Pid = $_.ProcessId
            Type = $type
        }
    }

    $rows | Format-Table -AutoSize
    Start-Sleep -Seconds $IntervalSeconds
}

