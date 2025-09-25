<#
.SYNOPSIS

    TODO

.EXAMPLE

    PS> .\Set-AvalonMinerPoolConfig.ps1 -MinerIP 192.168.0.236 -MinerPassword 'device admin password' -PoolID 2 -PoolURL 'stratum+tcp://example.com:333' -PoolUsername 'myworker' -PoolPassword '***'

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
    [string] $MinerPassword,

    [Parameter(Mandatory = $true)]
    [ValidateRange(0, 2)]
    [int] $PoolID,

    [Parameter(Mandatory = $true)]
    [string] $PoolURL,

    [Parameter(Mandatory = $true)]
    [string] $PoolUsername,

    [Parameter(Mandatory = $true)]
    [string] $PoolPassword
)

#######################################################################################################################
# Load Module

Import-Module "$PSScriptRoot\Modules\Avalon\Avalon.psm1"

#######################################################################################################################
# MAIN

$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'setpool' -Params "admin,$MinerPassword,$PoolID,$PoolURL,$PoolUsername,$PoolPassword"

$ApiObject.STATUS.Msg


#######################################################################################################################

Remove-Module Avalon
