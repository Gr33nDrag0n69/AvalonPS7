<#
.SYNOPSIS

    Set the target temperature of an Avalon miner.

.PARAMETER MinerIP

    IP address of the miner.

.PARAMETER Temperature

    Target temperature to set (in Celsius).

.EXAMPLE

    Set the target temperature of an Avalon miner to 75°C.

    PS> .\Set-AvalonMinerTargetTemperature.ps1 -MinerIP 192.168.0.236 -Temperature 75

.NOTES

    Each time the miner is restarted or the workmode is changed, the target temperature will reset to the default value.

    DEFAULT TEMPERATURES:

    Nano3S in WorkMode 0 : 80°C
    Nano3S in WorkMode 1 : 85°C
    Nano3S in WorkMode 2 : 90°C

    Q in WorkMode 0      : 65°C
    Q in WorkMode 1      : 80°C
    Q in WorkMode 2      : 85°C

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

    [Parameter(Mandatory = $true)]
    [ValidateRange(50, 90)]
    [int] $Temperature
)

#######################################################################################################################
# Load Module

Import-Module "$PSScriptRoot\Modules\Avalon\Avalon.psm1"

#######################################################################################################################
# MAIN

$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params "0,target-temp,$Temperature"

if ( ( $NULL -ne $ApiObject ) -and ( $NULL -ne $ApiObject.STATUS ) -and ( $NULL -ne $ApiObject.STATUS.Msg ) ) {

    if ($ApiObject.STATUS.Msg -like 'ASC 0 set OK*') {

        Write-Host 'Command executed successfully' -ForegroundColor Green

    } else {

        Write-Host "$($ApiObject.STATUS.Msg)" -ForegroundColor Red
    }

} else {

    Write-Host 'No valid response from Invoke-AvalonAPI' -ForegroundColor Red
}

#######################################################################################################################

Remove-Module Avalon
