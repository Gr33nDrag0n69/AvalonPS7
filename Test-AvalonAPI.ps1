
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

Import-Module "$PSScriptRoot\Modules\Avalon\Avalon.psm1"

#######################################################################################################################
# Script Configuration



#######################################################################################################################
# MAIN

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

# Test with parameters TODO
#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset'
#$ApiObject | ConvertTo-Json -Depth 100

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


Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
Write-Host 'lcd' -ForegroundColor Cyan
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'lcd'

$ApiObject | ConvertTo-Json -Depth 100

<#
$LcdData = [PSCustomObject] @{

    CurrentPool         = $ApiObject.LCD.'Current Pool'
    User                = $ApiObject.LCD.'User'

    LastValidWork       = Get-Date -Date ([DateTimeOffset]::FromUnixTimeSeconds($ApiObject.LCD.'Last Valid Work')).DateTime.ToLocalTime() -Format 'yyyy-MM-dd HH:mm:ss'
    LastShareDifficulty = Convert-AvalonDifficulty -Difficulty $ApiObject.LCD.'Last Share Difficulty'

    # Only work on Q model
    #LastShareTime       = New-TimeSpan -Seconds ($ApiObject.LCD.'Last Share Time' - $ApiObject.LCD.Elapsed)

    BestShare           = Convert-AvalonDifficulty -Difficulty $ApiObject.LCD.'Best Share'
    FoundBlocks         = $ApiObject.LCD.'Found Blocks'
}

$LcdData | Format-List *
#>

#######################################################################################################################

Remove-Module Avalon
