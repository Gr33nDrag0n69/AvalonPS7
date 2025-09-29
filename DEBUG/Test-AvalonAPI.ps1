
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


Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
Write-Host 'ascset' -ForegroundColor Cyan
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray

<#
Notes from r3mko on discord

{ "command": "ascset", "parameter": "0,fan-spd,90" }
Also for later reference, the fan-spd also takes a range: 10-100

help output:

Subcommands list:

loop
pdelay
frequency
led
hashpower
fan-spd
factory
reboot
softoff
softon
upgrade
worklevel
password
help
#>

# Help on ascset subcommands
#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,help'
#$ApiObject | ConvertTo-Json -Depth 100
#$ApiObject.STATUS.Msg


############################################################################

# FAN speed

Write-Host 'Set fan speed | Mode Exact | Value to 80%' -ForegroundColor DarkGreen
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,fan-spd,80'

#Write-Host 'Set fan speed | Mode Range | Value to 30-100%' -ForegroundColor DarkGreen
#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,fan-spd,30..100'

#Write-Host 'Set fan speed | Mode Auto' -ForegroundColor DarkGreen
#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,fan-spd,-1'


if ( $ApiObject.STATUS.Msg -like 'ASC 0 set OK*' ) {
    Write-Host 'Command executed successfully' -ForegroundColor Green
} else {
    Write-Host "$($ApiObject.STATUS.Msg)" -ForegroundColor Red
}

#######################################################################################################################

Remove-Module Avalon
