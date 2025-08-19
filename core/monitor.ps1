function Get-SystemUsage {
    $cpu = Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average | Select-Object -ExpandProperty Average
    $ram = Get-CimInstance Win32_OperatingSystem
    $totalRAM = [math]::Round($ram.TotalVisibleMemorySize / 1MB, 2)
    $freeRAM = [math]::Round($ram.FreePhysicalMemory / 1MB, 2)
    $usedRAM = [math]::Round($totalRAM - $freeRAM, 2)

    $disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
        [PSCustomObject]@{
            Drive      = $_.DeviceID
            SizeGB     = [math]::Round($_.Size / 1GB, 2)
            FreeGB     = [math]::Round($_.FreeSpace / 1GB, 2)
            UsedGB     = [math]::Round(($_.Size - $_.FreeSpace) / 1GB, 2)
            UsagePct   = [math]::Round((($_.Size - $_.FreeSpace) / $_.Size) * 100, 2)
        }
    }

    return [PSCustomObject]@{
        CPU_Load     = "$cpu %"
        RAM_Used     = "$usedRAM GB"
        RAM_Free     = "$freeRAM GB"
        RAM_Total    = "$totalRAM GB"
        Disks        = $disks
    }
}
