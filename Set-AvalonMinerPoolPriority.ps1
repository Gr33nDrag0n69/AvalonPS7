<#
.SYNOPSIS

    Set pool priority ordering.

.PARAMETER MinerIP

    IP address of the miner.

.PARAMETER PoolPriority

    Comma-separated list of pool priorities.
    Example: '1,0' sets Pool 1 as default and Pool 0 as backup, disabling Pool 2.
    Example: '0,1,2' sets Pool 0 as default, Pool 1 as first backup and Pool 2 as second backup.

.EXAMPLE

    Set Default Pool to 1, Backup Pool to 0, Disable Pool 2

    PS> .\Set-AvalonMinerPoolPriority.ps1 -MinerIP 192.168.0.236 -PoolPriority '1,0'

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
    [string] $PoolPriority
)

#######################################################################################################################
# Load Module

Import-Module "$PSScriptRoot\Modules\Avalon\Avalon.psm1"

#######################################################################################################################
# MAIN

$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'poolpriority' -Params "$PoolPriority"
#$ApiObject | ConvertTo-Json -Depth 100

$ApiObject.STATUS.Msg

#######################################################################################################################

Remove-Module Avalon
