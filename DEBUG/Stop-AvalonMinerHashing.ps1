<#
.SYNOPSIS

    Stop hashing on an Avalon miner

.PARAMETER MinerIP

    IP address of the miner.

.EXAMPLE

    TODO

    PS> .\Stop-AvalonMinerHashing.ps1 -MinerIP 192.168.0.236

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

# Test Current Status (only send command if miner current mode is active)

$Time = [int](Get-Date).ToUniversalTime().Subtract([datetime]'1970-01-01').TotalSeconds

$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params "0,softoff,1:$( $Time + 5 )"
#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params "0,softoff,1:$TwentySecondsLater"



if ( $ApiObject.STATUS.Msg -like 'ASC 0 set failed: Unknown option:*' ) {

    Write-Host 'The miner model is UNSUPPORTED. No action taken.' -ForegroundColor Yellow

} else {





    $ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params "0,softon,0:$( $Time + 7 )"



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
