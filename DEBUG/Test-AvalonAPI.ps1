
<#
.SYNOPSIS

    TODO

.EXAMPLE

    PS> .\Test-AvalonAPI.ps1 -MinerIP 192.168.0.236

.NOTES

    Author     : Gr33nDrag0n
    Version    : 1.0.0

#>

#Requires -Version 7.0

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateScript({
            if (-not [System.Net.IPAddress]::TryParse($_, [ref]$null)) {
                throw 'Invalid IP address format.'
            }

            $parsed_ip = [System.Net.IPAddress]::Parse($_)
            $bytes = $parsed_ip.GetAddressBytes()

            return (
                ($bytes[0] -eq 10) -or
                ($bytes[0] -eq 192 -and $bytes[1] -eq 168) -or
                ($bytes[0] -eq 172 -and $bytes[1] -ge 16 -and $bytes[1] -le 31)
            )
        })]
    [string] $MinerIP
)

# DEBUG
#Clear-Host

#######################################################################################################################
# Load Module

Import-Module "$PSScriptRoot\..\Modules\Avalon\Avalon.psm1"

#######################################################################################################################
# Script Configuration



#######################################################################################################################
# MAIN

#$ESTATS_ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'estats'
#$CustomData = Get-AvalonCustomData -ApiObject $ESTATS_ApiObject
#$CustomData | Format-List *


#Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
#Write-Host 'edevs' -ForegroundColor Cyan
#Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'edevs'
#$ApiObject | ConvertTo-Json -Depth 100

#Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
#Write-Host 'summary' -ForegroundColor Cyan
#Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray

#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'summary'
#$ApiObject | ConvertTo-Json -Depth 100


#Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
#Write-Host 'estats | RAW' -ForegroundColor Cyan
#Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'estats'
#$ApiObject | ConvertTo-Json -Depth 100

#Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
#Write-Host 'estats | CustomData' -ForegroundColor Cyan
#Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
#$CustomData = Get-AvalonCustomData -ApiObject $ApiObject
#$CustomData | Format-List *

#########################################################################################
# ASCSET | HELP (GET) EXAMPLE
#########################################################################################
<#
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,help'
$CommandListString = $ApiObject.STATUS.Msg -replace 'ASC 0 set info: ', ''
$CommandList = $CommandListString -split '\s+'
$CommandList -split '\|'
#>

#########################################################################################
# ASCSET | SOFTON / SOFTOFF (GET) EXAMPLE
#########################################################################################

#$Time = [int](Get-Date).ToUniversalTime().Subtract([datetime]'1970-01-01').TotalSeconds + 5

#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params "0,softoff,0:$Time"
#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params "0,softoff,1:$TwentySecondsLater"

#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params "0,softon,1:$Time"

#$ApiObject.STATUS.Msg


#########################################################################################
# ASCSET | WORKMODE & WORKLEVEL (GET & SET) EXAMPLES
#########################################################################################

<#
### `workmode`

**What it does:** GET/SET (`set_avalon_device_workmode`). Use textual `get`/`set` sub-commands in the handler parameters.

* GET: `get` (returns `workmode <value>`).
* SET: `set,<mode>` where `mode` must be `<= info->maxmode[0]` and device must not be in calibration.

# GET EXAMPLE

$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,workmode,get'
#$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg

# SET EXAMPLE

#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,workmode,set,2'
#$ApiObject | ConvertTo-Json -Depth 100
#$ApiObject.STATUS.Msg

# NOTE: the handler rejects changes if calibration (aging) is not finished or mode > maxmode.


### `worklevel`

**What it does:** GET/SET (`set_avalon_device_worklevel`). Format: `get` or `set,<level>`. `level` must be within bounds encoded in `info->worklvl[0]`.

# GET EXAMPLE

$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,worklevel,get'
#$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg

# SET EXAMPLE

#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,worklevel,set,3'
#$ApiObject | ConvertTo-Json -Depth 100
#$ApiObject.STATUS.Msg

# NOTE: changes are refused while calibration (aging) is running.


### `work_mode_lvl`

**What it does:** GET/SET combined (`set_avalon_work_mode_lvl`). Format:

* `get` → returns both current mode and level.
* `set,<mode>,<level>` → set both simultaneously (with validation and calibration checks).

# GET EXAMPLE

$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,work_mode_lvl,get'
#$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg

# SET EXAMPLE

#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,work_mode_lvl,set,1,2'
#$ApiObject | ConvertTo-Json -Depth 100
#$ApiObject.STATUS.Msg

#>
<#
Write-Host ''
Write-Host 'GET | ascset workmode' -ForegroundColor DarkCyan
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,workmode,get'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray

Write-Host ''
Write-Host 'GET | ascset worklevel' -ForegroundColor DarkCyan
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,worklevel,get'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray


Write-Host ''
Write-Host 'GET | ascset work_mode_lvl' -ForegroundColor DarkCyan
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,work_mode_lvl,get'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
#>

#######################################################################################################################

Remove-Module Avalon
