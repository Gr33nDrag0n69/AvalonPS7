
<#
.SYNOPSIS

    Show voltage information about an Avalon miner.

.PARAMETER MinerIP

    IP address of the miner.

.EXAMPLE

    PS> .\Show-AvalonMinerVoltage.ps1 -MinerIP 192.168.0.236

.NOTES

    Version    : 1.0.0
    Copyright (c) 2025 Gr33nDrag0n69
    SPDX-License-Identifier: Apache-2.0
#>

#Requires -Version 7.0

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateScript({
            if (-not [System.Net.IPAddress]::TryParse($_, [ref]$null)) {
                throw 'Invalid IP address format. Only Local Network IPv4 addresses are supported.'
            }

            $parsed_ip = [System.Net.IPAddress]::Parse($_)
            $bytes = $parsed_ip.GetAddressBytes()

            return (
                ($bytes[0] -eq 10) -or
                ($bytes[0] -eq 192 -and $bytes[1] -eq 168) -or
                ($bytes[0] -eq 172 -and $bytes[1] -ge 16 -and $bytes[1] -le 31)
            )
        })]
    [string] $MinerIP,

    [switch] $HideSensitiveInfo = $False
)

#######################################################################################################################
# Load Module

Import-Module "$PSScriptRoot\Modules\Avalon\Avalon.psm1"

#######################################################################################################################
# MAIN

<#
# Nano3S
PS[0 0 27406 4 0 3756 131]

# Q
PS[0 1214 2394 53 1292 2395 1414]

Index	Property name       Meaning / notes
0	    ErrorCode           Firmware error / status code (0 = OK typically)
1	    Reserved1           Reserved / unused (always 0 in comment)
2	    OutputVoltage       Measured output voltage (raw device unit; often mV but not guaranteed)
3	    OutputCurrent       Measured output current (raw unit; often mA or 0.01A — check device docs)
4	    Reserved2           Reserved / unused
5	    CommandedVoltage    Commanded/output target voltage (what controller attempts to set)
6	    OutputPower         Power reading, "poutwall" — likely watts (raw)
7	    MinAllowedVoltage   Minimum allowed voltage for set validation
8	    MaxAllowedVoltage   Maximum allowed voltage for set validation
9	    Reserved3           Reserved / unused

#>
# GET returns PSU/power info string for modules (handler `set_avalon_device_voltage` with no request).


$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,voltage'

$VoltageString = $ApiObject.STATUS.Msg -replace 'ASC 0 set info: ', ''

#Write-Host "Voltage String : $VoltageString" -ForegroundColor DarkCyan

$NumList = [regex]::Matches($VoltageString, '-?\d+') | ForEach-Object { [int]$_.Value }

$VoltageObject = [PSCustomObject]@{
    RawString            = $VoltageString
    Values               = , ($NumList)   # ensure this is an array-valued property
    ErrorCode            = if ($NumList.Count -ge 1) { $NumList[0] } else { $null } # index 0
    Reserved1            = if ($NumList.Count -ge 2) { $NumList[1] } else { $null } # index 1
    OutputVoltageRaw     = if ($NumList.Count -ge 3) { $NumList[2] } else { $null } # index 2
    OutputCurrentRaw     = if ($NumList.Count -ge 4) { $NumList[3] } else { $null } # index 3
    Reserved2            = if ($NumList.Count -ge 5) { $NumList[4] } else { $null } # index 4
    CommandedVoltageRaw  = if ($NumList.Count -ge 6) { $NumList[5] } else { $null } # index 5
    OutputPowerRaw       = if ($NumList.Count -ge 7) { $NumList[6] } else { $null } # index 6
    MinAllowedVoltageRaw = if ($NumList.Count -ge 8) { $NumList[7] } else { $null } # index 7
    MaxAllowedVoltageRaw = if ($NumList.Count -ge 9) { $NumList[8] } else { $null } # index 8
}

$VoltageObject | Format-List *
<#
# Best-effort mapping for 7 fields: keep standard names, show extra as 'Extra'
$err = $nums[0]
$ctrlV = & $fmtV $nums[1]
$maybeRailV = & $fmtV $nums[2]
$amps = & $fmtA $nums[3]
$watts = & $fmtW $nums[4]
$maybeRailSet = & $fmtV $nums[5]
$extraV = & $fmtV $nums[6]

$Output = [PSCustomObject]@{
    'ErrorCode'                = $err
    'ControllerVoltage'        = $ctrlV
    'Rail_or_HashVoltage_1'    = $maybeRailV
    'HashBoardsCurrent'        = $amps
    'HashBoardsPower'          = $watts
    'Rail_or_HashSetVoltage_1' = $maybeRailSet
    'ExtraVoltage_or_Rail_2'   = $extraV
    'Note'                     = '7-field format: model/firmware reports an extra rail or measurement. Verify with vendor docs or ascset help.'
}
#>


###############################################################################################################
# SET EXAMPLE

# SET accepts a single integer value and attempts to set PSU voltage if it falls within the per-module allowed range (`info->power_info[i][7]`..`info->power_info[i][8]`); otherwise it returns a range error.

#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,voltage,1150'
#$ApiObject | ConvertTo-Json -Depth 100
#$ApiObject.STATUS.Msg

# NOTE: valid numeric range is device-specific and read from info->power_info[*][7..8] on the device.


#######################################################################################################################

Remove-Module Avalon
