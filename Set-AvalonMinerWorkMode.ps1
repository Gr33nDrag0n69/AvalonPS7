<#
.SYNOPSIS

    Set the work mode of an Avalon miner.

.PARAMETER MinerIP

    IP address of the miner.

.PARAMETER WorkMode

    Work mode to set (0, 1, or 2).

    0 / Low / Eco
    1 / Medium / Standard
    2 / High / Super

.EXAMPLE

    PS> .\Set-AvalonMinerWorkMode.ps1 -MinerIP 192.168.0.236 -WorkMode 1

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

    [Parameter(Mandatory = $true)]
    [ValidateSet('0', '1', '2')]
    [string] $WorkMode
)

#######################################################################################################################
# Load Module

Import-Module "$PSScriptRoot\Modules\Avalon\Avalon.psm1"

#######################################################################################################################
# MAIN

$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params "0,workmode,set,$WorkMode"

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
