<#
.SYNOPSIS

    Output the pool configuration of an Avalon miner.

.PARAMETER MinerIP

    IP address of the miner.

.PARAMETER HideSensitiveInfo

    Hide sensitive information like pool URLs, usernames, and passwords.
    Mostly for screenshots or sharing output.

.EXAMPLE

    PS> .\Show-AvalonMinerPoolConfig.ps1 -MinerIP 192.168.0.236

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

    [switch] $HideSensitiveInfo = $False
)

#######################################################################################################################
# Load Module

Import-Module "$PSScriptRoot\Modules\Avalon\Avalon.psm1"

#######################################################################################################################
# MAIN

$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'pools'
#$ApiObject.POOLS | ConvertTo-Json -Depth 100

foreach ( $PoolObject in $ApiObject.POOLS ) {

    if ( $HideSensitiveInfo ) {

        $PoolObject.URL = "stratum+tcp://btc_0$($($PoolObject.POOL)).example.com:3333"
        $PoolObject.User = 'xxx'
        #$PoolObject.Password = 'xxx'
    }

    #$MinerInfo.ActivePool_LastValidWork = Get-Date -Date ([DateTimeOffset]::FromUnixTimeSeconds($LCD_ApiObject.LCD.'Last Valid Work')).DateTime.ToLocalTime() -Format 'yyyy-MM-dd HH:mm:ss'
    #$MinerInfo.ActivePool_LastShareDifficulty = Convert-AvalonDifficulty -Difficulty $LCD_ApiObject.LCD.'Last Share Difficulty'
    $LastShareTime = Get-Date -Date ([DateTimeOffset]::FromUnixTimeSeconds($PoolObject.'Last Share Time')).DateTime.ToLocalTime() -Format 'yyyy-MM-dd HH:mm:ss'

    Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray
    Write-Host "Pool Index: $($PoolObject.POOL)" -ForegroundColor Cyan
    Write-Host '--------------------------------------------------------------------------------' -ForegroundColor Gray

    Write-Host "    URL                     : $($PoolObject.URL)" -ForegroundColor White
    Write-Host "    Status                  : $($PoolObject.Status)" -ForegroundColor White
    Write-Host "    Priority                : $($PoolObject.Priority)" -ForegroundColor White
    #Write-Host "    Quota                   : $($PoolObject.Quota)" -ForegroundColor White
    #Write-Host "    Long Poll               : $($PoolObject.'Long Poll')" -ForegroundColor White
    Write-Host "    Getworks                : $($PoolObject.Getworks)" -ForegroundColor White
    Write-Host "    Accepted                : $($PoolObject.Accepted)" -ForegroundColor White
    Write-Host "    Rejected                : $($PoolObject.Rejected)" -ForegroundColor White
    Write-Host "    Works                   : $($PoolObject.Works)" -ForegroundColor White
    Write-Host "    Discarded               : $($PoolObject.Discarded)" -ForegroundColor White
    Write-Host "    Stale                   : $($PoolObject.Stale)" -ForegroundColor White
    Write-Host "    Get Failures            : $($PoolObject.'Get Failures')" -ForegroundColor White
    Write-Host "    Remote Failures         : $($PoolObject.'Remote Failures')" -ForegroundColor White
    Write-Host "    User                    : $($PoolObject.User)" -ForegroundColor White
    #Write-Host "    Password                : $($PoolObject.Password)" -ForegroundColor White
    Write-Host "    Last Share Time         : $($LastShareTime)" -ForegroundColor White
    #Write-Host "    Diff1 Shares            : $($PoolObject.'Diff1 Shares')" -ForegroundColor White
    #Write-Host "    Proxy Type              : $($PoolObject.'Proxy Type')" -ForegroundColor White
    #Write-Host "    Proxy                   : $($PoolObject.Proxy)" -ForegroundColor White
    #Write-Host "    Difficulty Accepted     : $(Convert-AvalonDifficulty -Difficulty $PoolObject.'Difficulty Accepted')" -ForegroundColor White
    #Write-Host "    Difficulty Rejected     : $(Convert-AvalonDifficulty -Difficulty $PoolObject.'Difficulty Rejected')" -ForegroundColor White
    #Write-Host "    Difficulty Stale        : $(Convert-AvalonDifficulty -Difficulty $PoolObject.'Difficulty Stale')" -ForegroundColor White
    #Write-Host "    Last Share Difficulty   : $(Convert-AvalonDifficulty -Difficulty $PoolObject.'Last Share Difficulty')" -ForegroundColor White
    #Write-Host "    Work Difficulty         : $(Convert-AvalonDifficulty -Difficulty $PoolObject.'Work Difficulty')" -ForegroundColor White
    Write-Host "    Has Stratum             : $($PoolObject.'Has Stratum')" -ForegroundColor White
    Write-Host "    Stratum Active          : $($PoolObject.'Stratum Active')" -ForegroundColor White
    Write-Host "    Stratum URL             : $($PoolObject.'Stratum URL')" -ForegroundColor White
    Write-Host "    Stratum Difficulty      : $(Convert-AvalonDifficulty -Difficulty $PoolObject.'Stratum Difficulty')" -ForegroundColor White
    #Write-Host "    Has Vmask               : $($PoolObject.'Has Vmask')" -ForegroundColor White
    #Write-Host "    Has GBT                 : $($PoolObject.'Has GBT')" -ForegroundColor White
    Write-Host "    Best Share              : $(Convert-AvalonDifficulty -Difficulty $PoolObject.'Best Share')" -ForegroundColor White
    Write-Host "    Pool Rejected%          : $($PoolObject.'Pool Rejected%')" -ForegroundColor White
    Write-Host "    Pool Stale%             : $($PoolObject.'Pool Stale%')" -ForegroundColor White
    Write-Host "    Bad Work                : $($PoolObject.'Bad Work')" -ForegroundColor White
    Write-Host "    Current Block Height    : $($PoolObject.'Current Block Height')" -ForegroundColor White
    Write-Host "    Current Block Version   : $($PoolObject.'Current Block Version')" -ForegroundColor White
    Write-Host ''
}


#######################################################################################################################

Remove-Module Avalon
