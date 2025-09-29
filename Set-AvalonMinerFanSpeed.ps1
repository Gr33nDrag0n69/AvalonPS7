<#
.SYNOPSIS

    Set the fan speed of an Avalon miner via the ascset API. USE AT YOUR OWN RISK(S).

.PARAMETER MinerIP

    IP address of the miner.

.PARAMETER Mode

    Select one of the three parameter sets: Exact, Range, Auto.

    - Auto: no additional numeric parameters (uses -1)
    - Exact: requires -Speed (15..100)
    - Range: requires -MinSpeed (15..100) and -MaxSpeed (15..100)

.PARAMETER Speed

    Required for Exact mode. Must be between 25 and 100.

    Set the fan speed to an exact value (25..100).
    Example: 80

.PARAMETER MinSpeed

    Required for Range mode. Must be between 25 and 100.

    Set the minimum allowed fan speed (25..100).
    Example: 30

.PARAMETER MaxSpeed
    Required for Range mode. Must be between 25 and 100.

    Set the maximum allowed fan speed (25..100).
    Example: 100

.EXAMPLE
    # Auto mode: let device auto-adjust (default)
    .\Set-AvalonMinerFanSpeed -MinerIP '192.168.1.100' -Mode Auto

.EXAMPLE
    # Exact mode: set the fan to 80%
    .\Set-AvalonMinerFanSpeed -MinerIP '192.168.1.100' -Mode Exact -Speed 80

.EXAMPLE
    # Range mode: set allowed range 30..100
    .\Set-AvalonMinerFanSpeed -MinerIP '192.168.1.100' -Mode Range -MinSpeed 30 -MaxSpeed 100

.NOTES

    Version    : 1.0.0
    Copyright (c) 2025 Gr33nDrag0n69
    SPDX-License-Identifier: Apache-2.0

#>

#Requires -Version 7.0

[CmdletBinding(DefaultParameterSetName = 'Auto')]
param(

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
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
    [string]$MinerIP,

    [Parameter(Mandatory = $true)]
    [ValidateSet('Auto', 'Exact', 'Range', IgnoreCase = $true)]
    [string]$Mode,

    [Parameter(Mandatory = $true, ParameterSetName = 'Exact')]
    [ValidateRange(25, 100)]
    [int]$Speed,

    [Parameter(Mandatory = $true, ParameterSetName = 'Range')]
    [ValidateRange(25, 100)]
    [int]$MinSpeed,

    [Parameter(Mandatory = $true, ParameterSetName = 'Range')]
    [ValidateRange(25, 100)]
    [int]$MaxSpeed
)


#######################################################################################################################
# Load Module

Import-Module "$PSScriptRoot\Modules\Avalon\Avalon.psm1"

#######################################################################################################################
# MAIN

$paramsStr = ''

switch ( $Mode ) {

    'Exact' {

        if ($Speed -lt 25 -or $Speed -gt 100) {

            Write-Host 'Speed must be between 25 and 100.' -ForegroundColor Red

        } else {

            $paramsStr = "0,fan-spd,$Speed"
        }

        break
    }

    'Range' {

        if ( $MinSpeed -lt 25 -or $MinSpeed -gt 100 ) {

            Write-Host 'MinSpeed value must be between 25 and 100.' -ForegroundColor Red

        } elseif ( $MaxSpeed -lt 25 -or $MaxSpeed -gt 100 ) {

            Write-Host 'MaxSpeed value must be between 25 and 100.' -ForegroundColor Red

        } elseif ($MinSpeed -gt $MaxSpeed) {

            Write-Host "MinSpeed ($MinSpeed) cannot be greater than MaxSpeed ($MaxSpeed)." -ForegroundColor Red

        } else {

            if ($MinSpeed -eq $MaxSpeed) {

                Write-Host "MinSpeed ($MinSpeed) is equal to MaxSpeed ($MaxSpeed). Consider using Exact mode instead." -ForegroundColor Yellow
            }

            $paramsStr = "0,fan-spd,$MinSpeed..$MaxSpeed"
        }

        break
    }

    'Auto' {

        $paramsStr = '0,fan-spd,-1'

        break
    }
}

if ( $paramsStr -ne '' ) {

    Write-Host "Mode $Mode | API Params $paramsStr" -ForegroundColor DarkCyan

    $ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params $paramsStr

    if ( ( $NULL -ne $ApiObject ) -and ( $NULL -ne $ApiObject.STATUS ) -and ( $NULL -ne $ApiObject.STATUS.Msg ) ) {

        if ($ApiObject.STATUS.Msg -like 'ASC 0 set OK*') {

            Write-Host 'Command executed successfully' -ForegroundColor Green

        } else {

            Write-Host "$($ApiObject.STATUS.Msg)" -ForegroundColor Red
        }

    } else {

        Write-Host 'No valid response from Invoke-AvalonAPI' -ForegroundColor Red
    }

} else {

    Write-Host 'Invalid parameters set.' -ForegroundColor Red
}


#######################################################################################################################

Remove-Module Avalon
