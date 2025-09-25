
<#
.SYNOPSIS

    TODO

.EXAMPLE

    PS> .\Show-AvalonMinerInfo.ps1 -MinerIP 192.168.0.236

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

    [switch] $HideSensitiveInfo = $False
)

#######################################################################################################################
# Load Module

Import-Module "$PSScriptRoot\Modules\Avalon\Avalon.psm1"

#######################################################################################################################
# MAIN

$MinerInfo = Get-AvalonMinerInfo -IP $MinerIP

if ( $NULL -ne $MinerInfo ) {

    if ( $HideSensitiveInfo ) {

        $MinerInfo.IP = 'xxx.xxx.xxx.xxx'

    } else {

        $MinerInfo.IP = $MinerIP
    }

    Write-Host ''
    Write-Host "IP                  : $($MinerInfo.IP)" -ForegroundColor White
    Write-Host "Model               : $($MinerInfo.Model)" -ForegroundColor White
    Write-Host ''
    Write-Host "Status              : $($MinerInfo.Status)" -ForegroundColor White
    Write-Host "Work Mode           : $($MinerInfo.WorkMode)" -ForegroundColor White
    Write-Host "Max Power Output    : $($MinerInfo.MaxPowerOutput) W" -ForegroundColor White
    Write-Host ''

    <#
    Write-Host '# Hash Rate | Avalon CustomData' -ForegroundColor DarkCyan
    Write-Host ''
    Write-Host "    Average         : $($MinerInfo.HashRate_Average_THS) TH/s" -ForegroundColor White
    Write-Host "    Momentary       : $($MinerInfo.HashRate_Momentary_THS) TH/s" -ForegroundColor White
    Write-Host "    Current         : $($MinerInfo.HashRate_Current_THS) TH/s" -ForegroundColor White
    Write-Host "    Measured        : $($MinerInfo.HashRate_Measured_THS) TH/s" -ForegroundColor White
    Write-Host ''

    Write-Host '# Hash Rate | CG Miner' -ForegroundColor DarkCyan
    Write-Host ''
    Write-Host "    Average         : $($MinerInfo.HashRate_CGM_Average_THS) TH/s" -ForegroundColor White
    Write-Host "    5s              : $($MinerInfo.HashRate_CGM_5s_THS) TH/s" -ForegroundColor White
    Write-Host "    1m              : $($MinerInfo.HashRate_CGM_1m_THS) TH/s" -ForegroundColor White
    Write-Host "    5m              : $($MinerInfo.HashRate_CGM_5m_THS) TH/s" -ForegroundColor White
    Write-Host "    15m             : $($MinerInfo.HashRate_CGM_15m_THS) TH/s" -ForegroundColor White
    Write-Host ''
    #>

    Write-Host '# Hash Rate' -ForegroundColor DarkCyan
    Write-Host ''
    Write-Host "    Current         : $($MinerInfo.HashRate_Current_THS) TH/s" -ForegroundColor White
    Write-Host "    Average         : $($MinerInfo.HashRate_Average_THS) TH/s" -ForegroundColor White
    Write-Host ''

    Write-Host '# Fan(s)' -ForegroundColor DarkCyan
    Write-Host ''
    Write-Host "    Fan PCT         : $($MinerInfo.FanSpeed_PCT) %" -ForegroundColor White
    Write-Host "    Fan 1           : $($MinerInfo.Fan1Speed_RPM) RPM" -ForegroundColor White
    if ( $MinerInfo.Model -eq 'Q' ) {
        Write-Host "    Fan 2           : $($MinerInfo.Fan2Speed_RPM) RPM" -ForegroundColor White
        Write-Host "    Fan 3           : $($MinerInfo.Fan3Speed_RPM) RPM" -ForegroundColor White
        Write-Host "    Fan 4           : $($MinerInfo.Fan4Speed_RPM) RPM" -ForegroundColor White
    }
    Write-Host ''

    Write-Host '# Temperature' -ForegroundColor DarkCyan
    Write-Host ''
    if ( $MinerInfo.Model -eq 'Q' ) {
        Write-Host "    Case Inlet      : $($MinerInfo.Temp_CaseInlet) °C" -ForegroundColor White
        Write-Host "    Hashboard In    : $($MinerInfo.Temp_HashboardIn) °C" -ForegroundColor White
        Write-Host "    Hashboard Out   : $($MinerInfo.Temp_HashboardOut) °C" -ForegroundColor White
    }
    Write-Host "    ASIC Target     : $($MinerInfo.Temp_AsicTarget) °C" -ForegroundColor White
    Write-Host "    ASIC Average    : $($MinerInfo.Temp_AsicAverage) °C" -ForegroundColor White
    Write-Host "    ASIC Maximum    : $($MinerInfo.Temp_AsicMaximum) °C" -ForegroundColor White
    Write-Host ''

    Write-Host '# Pool' -ForegroundColor DarkCyan
    Write-Host ''
    Write-Host '    Address         : TODO' -ForegroundColor White
    Write-Host '    Username        : TODO' -ForegroundColor White
    Write-Host '    Best Share      : TODO' -ForegroundColor White
    Write-Host '    Pool Rejected % : TODO' -ForegroundColor White
    Write-Host '    Pool Stale %    : TODO' -ForegroundColor White
    Write-Host ''

    Write-Host '# Misc.' -ForegroundColor DarkCyan
    Write-Host ''
    Write-Host "    Uptime          : $($MinerInfo.Uptime)" -ForegroundColor White
    Write-Host ''


    # DEBUG
    #$MinerInfo | Format-List *
}

#######################################################################################################################

Remove-Module Avalon
