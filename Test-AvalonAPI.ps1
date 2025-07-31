
<#
.SYNOPSIS

    TODO

.EXAMPLE

    PS> .\Test-AvalonAPI.ps1 -IP 192.168.0.236

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
    [string] $IP,

    [Parameter(Mandatory = $false)]
    [ValidateRange(1, 65535)]
    [int] $Port = 4028
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

<#
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
Write-Host 'version' -ForegroundColor Cyan
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
#$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'version'
#$ApiObject | ConvertTo-Json -Depth 100


Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
Write-Host 'config' -ForegroundColor Cyan
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
#$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'config'
#$ApiObject | ConvertTo-Json -Depth 100


Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
Write-Host 'devs' -ForegroundColor Cyan
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
#$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'devs'
#$ApiObject | ConvertTo-Json -Depth 100


Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
Write-Host 'edevs' -ForegroundColor Cyan
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
#$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'edevs'
#$ApiObject | ConvertTo-Json -Depth 100


Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
Write-Host 'pools' -ForegroundColor Cyan
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
#$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'pools'
#$ApiObject | ConvertTo-Json -Depth 100


Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
Write-Host 'summary' -ForegroundColor Cyan
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
#$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'summary'
#$ApiObject | ConvertTo-Json -Depth 100

#$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command "switchpool"
#$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command "poolpriority"
#$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command "enablepool"
#$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command "disablepool"
#$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command "setpool"

Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
Write-Host 'devdetails' -ForegroundColor Cyan
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
#$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'devdetails'
#$ApiObject | ConvertTo-Json -Depth 100

#>
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
Write-Host 'stats | RAW' -ForegroundColor Cyan
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
#$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'stats'
#$ApiObject | ConvertTo-Json -Depth 100

Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
Write-Host 'stats | CustomData' -ForegroundColor Cyan
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray

#$CustomData = Get-AvalonCustomData -ApiObject $ApiObject
#$CustomData | Format-List *

Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
Write-Host 'estats | RAW' -ForegroundColor Cyan
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'estats'
#$ApiObject | ConvertTo-Json -Depth 100

Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
Write-Host 'estats | CustomData' -ForegroundColor Cyan
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray

$CustomData = Get-AvalonCustomData -ApiObject $ApiObject
$CustomData | Format-List *

Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
Write-Host 'litestats | RAW' -ForegroundColor Cyan
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
#$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'litestats'
#$ApiObject | ConvertTo-Json -Depth 100

Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
Write-Host 'litestats | CustomData' -ForegroundColor Cyan
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray

#$CustomData = Get-AvalonCustomData -ApiObject $ApiObject
#$CustomData | Format-List *

<#
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
Write-Host 'check' -ForegroundColor Cyan
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
#$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'check'
#$ApiObject | ConvertTo-Json -Depth 100


Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
Write-Host 'coin' -ForegroundColor Cyan
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
#$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'coin'
#$ApiObject | ConvertTo-Json -Depth 100


Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
Write-Host 'ascset' -ForegroundColor Cyan
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray

# Test with parameters TODO
#$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'ascset'
#$ApiObject | ConvertTo-Json -Depth 100


Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
Write-Host 'lcd' -ForegroundColor Cyan
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
#$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'lcd'
#$ApiObject | ConvertTo-Json -Depth 100


Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
Write-Host 'lockstats' -ForegroundColor Cyan
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
#$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'lockstats'
#$ApiObject | ConvertTo-Json -Depth 100


Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
Write-Host 'time' -ForegroundColor Cyan
Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
#$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'time'
#$ApiObject | ConvertTo-Json -Depth 100


Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray

#>

#######################################################################################################################

Remove-Module Avalon
