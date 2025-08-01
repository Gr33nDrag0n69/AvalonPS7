
<#
.SYNOPSIS

    TODO

.EXAMPLE

    PS> .\Export-AvalonApiData.ps1 -IP 192.168.0.236

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

$DebugOutputDirectory = "$PSScriptRoot\DEBUG"
$DebugOutputIP = $IP -replace '\.', '-'
$DebugOutputTimestamp = (Get-Date).ToString('yyyyMMdd-HHmmss')


#######################################################################################################################
# MAIN

# Version

$DebugOutputFile = "$($DebugOutputDirectory)\$($DebugOutputTimestamp)_AvalonAPI_Version_$($DebugOutputIP).json"
Write-Host "Writing 'version' data to $DebugOutputFile" -ForegroundColor Cyan
$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'version'
$ApiObject | ConvertTo-Json -Depth 100 | Out-File -FilePath $DebugOutputFile -Encoding UTF8

# Config

$DebugOutputFile = "$($DebugOutputDirectory)\$($DebugOutputTimestamp)_AvalonAPI_Config_$($DebugOutputIP).json"
Write-Host "Writing 'config' data to $DebugOutputFile" -ForegroundColor Cyan
$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'config'
$ApiObject | ConvertTo-Json -Depth 100 | Out-File -FilePath $DebugOutputFile -Encoding UTF8

# Devs

$DebugOutputFile = "$($DebugOutputDirectory)\$($DebugOutputTimestamp)_AvalonAPI_Devs_$($DebugOutputIP).json"
Write-Host "Writing 'devs' data to $DebugOutputFile" -ForegroundColor Cyan
$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'devs'
$ApiObject | ConvertTo-Json -Depth 100 | Out-File -FilePath $DebugOutputFile -Encoding UTF8

# EDevs

$DebugOutputFile = "$($DebugOutputDirectory)\$($DebugOutputTimestamp)_AvalonAPI_EDevs_$($DebugOutputIP).json"
Write-Host "Writing 'edevs' data to $DebugOutputFile" -ForegroundColor Cyan
$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'edevs'
$ApiObject | ConvertTo-Json -Depth 100 | Out-File -FilePath $DebugOutputFile -Encoding UTF8

# Pools

$DebugOutputFile = "$($DebugOutputDirectory)\$($DebugOutputTimestamp)_AvalonAPI_Pools_$($DebugOutputIP).json"
Write-Host "Writing 'pools' data to $DebugOutputFile" -ForegroundColor Cyan
$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'pools'
$ApiObject | ConvertTo-Json -Depth 100 | Out-File -FilePath $DebugOutputFile -Encoding UTF8


#$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command "switchpool"
#$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command "poolpriority"
#$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command "enablepool"
#$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command "disablepool"
#$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command "setpool"

# Summary

$DebugOutputFile = "$($DebugOutputDirectory)\$($DebugOutputTimestamp)_AvalonAPI_Summary_$($DebugOutputIP).json"
Write-Host "Writing 'summary' data to $DebugOutputFile" -ForegroundColor Cyan
$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'summary'
$ApiObject | ConvertTo-Json -Depth 100 | Out-File -FilePath $DebugOutputFile -Encoding UTF8

# DevDetails
$DebugOutputFile = "$($DebugOutputDirectory)\$($DebugOutputTimestamp)_AvalonAPI_DevDetails_$($DebugOutputIP).json"
Write-Host "Writing 'devdetails' data to $DebugOutputFile" -ForegroundColor Cyan
$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'devdetails'
$ApiObject | ConvertTo-Json -Depth 100 | Out-File -FilePath $DebugOutputFile -Encoding UTF8

# Stats
$DebugOutputFile = "$($DebugOutputDirectory)\$($DebugOutputTimestamp)_AvalonAPI_Stats_$($DebugOutputIP).json"
Write-Host "Writing 'stats' data to $DebugOutputFile" -ForegroundColor Cyan
$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'stats'
$ApiObject | ConvertTo-Json -Depth 100 | Out-File -FilePath $DebugOutputFile -Encoding UTF8

# EStats
$DebugOutputFile = "$($DebugOutputDirectory)\$($DebugOutputTimestamp)_AvalonAPI_EStats_$($DebugOutputIP).json"
Write-Host "Writing 'estats' data to $DebugOutputFile" -ForegroundColor Cyan
$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'estats'
$ApiObject | ConvertTo-Json -Depth 100 | Out-File -FilePath $DebugOutputFile -Encoding UTF8

# LiteStats
$DebugOutputFile = "$($DebugOutputDirectory)\$($DebugOutputTimestamp)_AvalonAPI_LiteStats_$($DebugOutputIP).json"
Write-Host "Writing 'litestats' data to $DebugOutputFile" -ForegroundColor Cyan
$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'litestats'
$ApiObject | ConvertTo-Json -Depth 100 | Out-File -FilePath $DebugOutputFile -Encoding UTF8

# Coin
$DebugOutputFile = "$($DebugOutputDirectory)\$($DebugOutputTimestamp)_AvalonAPI_Coin_$($DebugOutputIP).json"
Write-Host "Writing 'coin' data to $DebugOutputFile" -ForegroundColor Cyan
$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'coin'
$ApiObject | ConvertTo-Json -Depth 100 | Out-File -FilePath $DebugOutputFile -Encoding UTF8

# AscSet | TODO: Test with parameters
<#
$DebugOutputFile = "$($DebugOutputDirectory)\$($DebugOutputTimestamp)_AvalonAPI_AscSet_$($DebugOutputIP).json"
Write-Host "Writing 'ascset' data to $DebugOutputFile" -ForegroundColor Cyan
$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'ascset'
$ApiObject | ConvertTo-Json -Depth 100 | Out-File -FilePath $DebugOutputFile -Encoding UTF8
#>

# Lcd
$DebugOutputFile = "$($DebugOutputDirectory)\$($DebugOutputTimestamp)_AvalonAPI_Lcd_$($DebugOutputIP).json"
Write-Host "Writing 'lcd' data to $DebugOutputFile" -ForegroundColor Cyan
$ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'lcd'
$ApiObject | ConvertTo-Json -Depth 100 | Out-File -FilePath $DebugOutputFile -Encoding UTF8


#######################################################################################################################

Remove-Module Avalon
