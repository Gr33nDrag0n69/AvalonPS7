
<#
.SYNOPSIS

    Output HW & SW version information about an Avalon miner.

.PARAMETER MinerIP

    IP address of the miner.

.PARAMETER HideSensitiveInfo

    Hide sensitive information like pool URLs, usernames, and passwords.
    Mostly for screenshots or sharing output.

.EXAMPLE

    PS> .\Show-AvalonMinerVersion.ps1 -MinerIP 192.168.0.236

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

$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'version'

$VersionObject = $ApiObject.VERSION[0]

$Firmware = @($VersionObject.LVERSION, $VersionObject.BVERSION, $VersionObject.CGVERSION) | Where-Object { -not [string]::IsNullOrEmpty($_) } | Select-Object -First 1

$CGMinerVersion = try {
    [version]$VersionObject.CGMiner
} catch {
    $VersionObject.CGMiner
}

$ApiVersion = try {
    [version]$VersionObject.API
} catch {
    $VersionObject.API
}

# Compose final, human-friendly object
$AvalonInfo = [PSCustomObject] @{

    Name           = $VersionObject.PROD
    Model          = $VersionObject.MODEL

    HardwareType   = $VersionObject.HWTYPE
    SoftwareType   = $VersionObject.SWTYPE

    CGMinerVersion = $CGMinerVersion
    ApiVersion     = $ApiVersion


    Firmware       = $Firmware

    SerialNumber   = ($VersionObject.DNA).ToString().ToUpper()
    MacAddress     = Format-AvalonMinerMacAddress -MAC $VersionObject.MAC
}

# Output result
#$AvalonInfo | Format-List -Force

if ( $HideSensitiveInfo ) {

    $AvalonInfo.SerialNumber = '0123456789ABCDEF'
    $AvalonInfo.MacAddress = 'XX:XX:XX:XX:XX:XX'
}

Write-Host ''
Write-Host "Name             : $($AvalonInfo.Name)"
Write-Host "Model            : $($AvalonInfo.Model)"
Write-Host "Serial Number    : $($AvalonInfo.SerialNumber)"
Write-Host "MAC Address      : $($AvalonInfo.MacAddress)"
Write-Host ''
Write-Host "CGMiner Version  : $($AvalonInfo.CGMinerVersion)"
Write-Host "API Version      : $($AvalonInfo.ApiVersion)"
Write-Host ''
Write-Host "Firmware         : $($AvalonInfo.Firmware)"
Write-Host "Hardware Type    : $($AvalonInfo.HardwareType)"
Write-Host "Software Type    : $($AvalonInfo.SoftwareType)"
Write-Host ''

#######################################################################################################################

Remove-Module Avalon
