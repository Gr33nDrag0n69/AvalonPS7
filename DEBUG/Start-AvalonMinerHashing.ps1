<#
.SYNOPSIS

    Start hashing on an Avalon miner

.PARAMETER MinerIP

    IP address of the miner.

.EXAMPLE

    TODO

    PS> .\Start-AvalonMinerHashing.ps1 -MinerIP 192.168.0.236

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
    [string] $MinerIP
)

#######################################################################################################################
# Load Module

Import-Module "$PSScriptRoot\Modules\Avalon\Avalon.psm1"

#######################################################################################################################
# MAIN

# TODO: Test current status (only send command if miner current mode is inactive)

$Time = [int](Get-Date).ToUniversalTime().Subtract([datetime]'1970-01-01').TotalSeconds

$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params "0,softoff,0:$( $Time + 5 )"



if ( $ApiObject.STATUS.Msg -like 'ASC 0 set failed: Unknown option:*' ) {

    Write-Host 'The miner model is UNSUPPORTED. No action taken.' -ForegroundColor Yellow

} else {

    Write-Host "ASCSET | 0,softoff,0:$( $Time + 5 ) | $($ApiObject.STATUS.Msg)" -ForegroundColor Gray

    Write-Host 'Command executed successfully' -ForegroundColor Green

    $ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params "0,softon,1:$( $Time + 7 )"

    Write-Host "ASCSET | 0,softon,1:$( $Time + 7 ) | $($ApiObject.STATUS.Msg)" -ForegroundColor DarkCyan

}

# "ASC 0 set info: success softoff:*"

# "ASC 0 set info: success softon:*"

<#
if ( ( $NULL -ne $ApiObject ) -and ( $NULL -ne $ApiObject.STATUS ) -and ( $NULL -ne $ApiObject.STATUS.Msg ) ) {

    if ($ApiObject.STATUS.Msg -like 'ASC 0 set OK*') {

        Write-Host 'Command executed successfully' -ForegroundColor Green

    } else {

        Write-Host "$($ApiObject.STATUS.Msg)" -ForegroundColor Red
    }

} else {

    Write-Host 'No valid response from Invoke-AvalonAPI' -ForegroundColor Red
}
#>

#######################################################################################################################

Remove-Module Avalon
