<#

Get-Counter '\Memory\Available Bytes'
Get-Counter '\Memory\% Committed Bytes In Use'
Get-Counter '\Memory\Committed Bytes'

Get-Counter '\LogicalDisk(*)\Disk Bytes/sec'
Get-Counter '\LogicalDisk(*)\Disk Read Bytes/sec'
Get-Counter '\LogicalDisk(*)\Disk Write Bytes/sec'

Get-Counter '\Memory\Pool Paged Bytes'
Get-Counter '\Memory\Free & Zero Page List Bytes'

Get-Counter '\Memory\Page Faults/sec'
Get-Counter '\Memory\Available Bytes'
Get-Counter '\Memory\Committed Bytes'
Get-Counter '\Memory\Commit Limit'
Get-Counter '\Memory\Write Copies/sec'
Get-Counter '\Memory\Transition Faults/sec'
Get-Counter '\Memory\Cache Faults/sec'
Get-Counter '\Memory\Demand Zero Faults/sec'
Get-Counter '\Memory\Pages/sec'
Get-Counter '\Memory\Pages Input/sec'
Get-Counter '\Memory\Page Reads/sec'
Get-Counter '\Memory\Pages Output/sec'
Get-Counter '\Memory\Pool Paged Bytes'
Get-Counter '\Memory\Pool Nonpaged Bytes'
Get-Counter '\Memory\Page Writes/sec'
Get-Counter '\Memory\Pool Paged Allocs'
Get-Counter '\Memory\Pool Nonpaged Allocs'
Get-Counter '\Memory\Free System Page Table Entries'
Get-Counter '\Memory\Cache Bytes'
Get-Counter '\Memory\Cache Bytes Peak'
Get-Counter '\Memory\Pool Paged Resident Bytes'
Get-Counter '\Memory\System Code Total Bytes'
Get-Counter '\Memory\System Code Resident Bytes'
Get-Counter '\Memory\System Driver Total Bytes'
Get-Counter '\Memory\System Driver Resident Bytes'
Get-Counter '\Memory\System Cache Resident Bytes'
Get-Counter '\Memory\% Committed Bytes In Use'
Get-Counter '\Memory\Available KBytes'
Get-Counter '\Memory\Available MBytes'
Get-Counter '\Memory\Transition Pages RePurposed/sec'
Get-Counter '\Memory\Free & Zero Page List Bytes'
Get-Counter '\Memory\Modified Page List Bytes'
Get-Counter '\Memory\Standby Cache Reserve Bytes'
Get-Counter '\Memory\Standby Cache Normal Priority Bytes'
Get-Counter '\Memory\Standby Cache Core Bytes'
Get-Counter '\Memory\Long-Term Average Standby Cache Lifetime (s)'

#>
<#

#Harddisk usage
Get-Counter '\PhysicalDisk(*)\Current Disk Queue Length'
Get-Counter '\PhysicalDisk(*)\Avg. Disk Queue Length'

#Network usage
Get-Counter '\Network Interface(*)\Packets/sec' | Select-Object -ExpandProperty CounterSamples | Select-Object InstanceName, CookedValue
Get-Counter '\Network Interface(*)\Packets Received Unicast/sec' | Select-Object -ExpandProperty CounterSamples | Select-Object InstanceName, CookedValue
Get-Counter '\Network Interface(*)\Packets Received Non-Unicast/sec' | Select-Object -ExpandProperty CounterSamples | Select-Object InstanceName, CookedValue
Get-Counter '\Network Interface(*)\Packets Received Discarded' | Select-Object -ExpandProperty CounterSamples | Select-Object InstanceName, CookedValue
Get-Counter '\Network Interface(*)\Packets Received Errors' | Select-Object -ExpandProperty CounterSamples | Select-Object InstanceName, CookedValue
Get-Counter '\Network Interface(*)\Packets Received Unknown' | Select-Object -ExpandProperty CounterSamples | Select-Object InstanceName, CookedValue
Get-Counter '\Network Interface(*)\Packets Sent Unicast/sec' | Select-Object -ExpandProperty CounterSamples | Select-Object InstanceName, CookedValue
Get-Counter '\Network Interface(*)\Packets Sent Non-Unicast/sec' | Select-Object -ExpandProperty CounterSamples | Select-Object InstanceName, CookedValue
Get-Counter '\Network Interface(*)\Packets Outbound Discarded' | Select-Object -ExpandProperty CounterSamples | Select-Object InstanceName, CookedValue
Get-Counter '\Network Interface(*)\Packets Outbound Errors' | Select-Object -ExpandProperty CounterSamples | Select-Object InstanceName, CookedValue

#>

[CmdletBinding()]
Param(

    [Parameter(Mandatory=$False,Position=1)]
    [string]$ComputerName = 'localhost'

)

Begin {

    #Import-Module 'D:\Program Files (x86)\PRTG Network Monitor\Custom Sensors\EXEXML\PrtgCustomTools'
    
    $Counters = @(
        
        '\Processor(*)\% Processor Time'
        '\LogicalDisk(*)\% Free Space'
        '\LogicalDisk(*)\Free Megabytes'
        '\Paging File(*)\% Usage'
        '\Network Interface(*)\Current Bandwidth'
        '\Network Interface(*)\Bytes Total/sec'
        '\Network Interface(*)\Bytes Received/sec'
        '\Network Interface(*)\Bytes Sent/sec'
        '\Network Interface(*)\Packets/sec'
        '\Network Interface(*)\Packets Received Unicast/sec'
        '\Network Interface(*)\Packets Received Non-Unicast/sec'
        '\Network Interface(*)\Packets Received Discarded'
        '\Network Interface(*)\Packets Received Errors'
        '\Network Interface(*)\Packets Received Unknown'
        '\Network Interface(*)\Packets Sent Unicast/sec'
        '\Network Interface(*)\Packets Sent Non-Unicast/sec'
        '\Network Interface(*)\Packets Outbound Discarded'
        '\Network Interface(*)\Packets Outbound Errors'
        '\System\System Up Time'

    )
    $PublishedResults = @()

}
Process {
    
    $RawValues = (Get-Counter -ComputerName $ComputerName -Counter $Counters).counterSamples
    
    #Total CPU usage
    $TotalCpuUsage = ($RawValues).Where{ ($_.Path -like "*processor time*") -and ($_.InstanceName -eq "_total") }.CookedValue
    $PublishedResults += Create-PrtgResult -Channel "Total CPU usage" -Value $TotalCpuUsage -Unit CPU -Float 1 -DecimalMode Auto -LimitMode 1 -LimitMaxError 95 -LimitMaxWarning 85 
    
    #Per CPU usage
    $PublishedResults += ($RawValues).Where{ ($_.Path -like "*processor time*") -and ($_.InstanceName -ne "_total") } | ForEach-Object {
        
        $Cpu = $_
        $CpuUsage = $Cpu.CookedValue
        $CpuNumber = [int]$Cpu.InstanceName + 1
        
        Create-PrtgResult -Channel "CPU $CpuNumber Usage" -Value $CpuUsage -Unit CPU -Float 1 -DecimalMode Auto -LimitMode 1 -LimitMaxError 95 -LimitMaxWarning 85
    
    }
    
    #Disk usage
    $PublishedResults += ($RawValues).Where{ ($_.Path -like "*logicaldisk*") -and ($_.InstanceName -like "*:*") } | Group-Object InstanceName | ForEach-Object {
        
        $Disk = $_.Group
        $DiskName = (Get-Culture).TextInfo.ToTitleCase($_.Name)
        $DiskSpacePercentage = $Disk.Where{ ($_.Path -like "*% Free Space*") }.CookedValue
        $DiskSpaceUsage = ($Disk.Where{ ($_.Path -like "*Free Megabytes*") }).CookedValue 
        
        Create-PrtgResult -Channel "Drive $DiskName Free Percentage" -Value $DiskSpacePercentage -Unit CPU -Float 1 -DecimalMode Auto -LimitMode 1 -LimitMinWarning 15 -LimitMinError 5
        Create-PrtgResult -Channel "Drive $DiskName Free Space" -Value ($DiskSpaceUsage * 1024 * 1024 ) -Unit BytesDisk -Float 0
    
    }

    #Total Paging File usage
    $TotalPageFileUsage = ($RawValues).Where{ ($_.Path -like "*paging file*") -and ($_.InstanceName -eq "_total") }.CookedValue
    $PublishedResults += Create-PrtgResult -Channel "Total Page File usage" -Value $TotalPageFileUsage -Unit Percent -Float 1 -DecimalMode Auto -LimitMode 1 -LimitMaxError 90 -LimitMaxWarning 60

    #Network Usage
    $PublishedResults += ($RawValues).Where{ ($_.Path -like "*Network Interface*") -and ($_.InstanceName -notlike "*isatap*") -and ($_.InstanceName -notlike "*local area connection`**") } | Group-Object InstanceName | ForEach-Object {
        $Interface = $_.Group
        $InterfaceName = (Get-Culture).TextInfo.ToTitleCase($_.Name)
        $InterfaceTraffic = $Interface.Where{ ($_.Path -like "*\Network Interface(*)\Bytes Total/sec") }.CookedValue
        $InterfaceBandwith = $Interface.Where{ ($_.Path -like "*\Network Interface(*)\Current Bandwidth") }.CookedValue /8 
        $InterfaceTrafficIn = $Interface.Where{ ($_.Path -like "*\Network Interface(*)\Bytes Received/sec") }.CookedValue
        $InterfaceTrafficOut = $Interface.Where{ ($_.Path -like "*\Network Interface(*)\Bytes Sent/sec") }.CookedValue
        $InterfacePackets = $Interface.Where{ ($_.Path -like "*\Network Interface(*)\Packets/sec") }.CookedValue
        $InterfacePercentage = $InterfaceTraffic / $InterfaceBandwith * 100
        
        Create-PrtgResult -Channel "$InterfaceName Traffic Total" -Value $InterfaceTraffic -Unit BytesBandwidth -SpeedSize Byte -VolumeSize MegaByte -Float 0
        Create-PrtgResult -Channel "$InterfaceName Traffic In" -Value $InterfaceTrafficIn -Unit BytesBandwidth -SpeedSize Byte -VolumeSize MegaByte -Float 1 -DecimalMode Auto
        Create-PrtgResult -Channel "$InterfaceName Traffic Out" -Value $InterfaceTrafficOut -Unit BytesBandwidth -SpeedSize Byte -VolumeSize MegaByte -Float 1 -DecimalMode Auto
        Create-PrtgResult -Channel "$InterfaceName Packets" -Value $InterfacePackets -Unit Custom -CustomUnit 'p/s' -Float 1 -DecimalMode Auto
        Create-PrtgResult -Channel "$InterfaceName Usage Percentage" -Value $InterfacePercentage -Unit Percent -Float 1 -DecimalMode Auto
    
    }

    #Uptime
    $Uptime = (New-TimeSpan -Seconds ($RawValues.Where{ $_.Path -like "*system up time*" }).cookedvalue).TotalSeconds
    $PublishedResults += Create-PrtgResult -Channel "Uptime" -Value $Uptime -Unit TimeSeconds
    
}
End {

    Publish-PrtgResult -Publish $PublishedResults

}