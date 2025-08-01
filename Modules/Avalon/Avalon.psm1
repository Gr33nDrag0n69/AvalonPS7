
#######################################################################################################################
# PUBLIC
#######################################################################################################################

function Invoke-AvalonAPI {

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
        [int] $Port = 4028,

        [Parameter(Mandatory = $true)]
        [string] $Command = ''
    )

    $client = New-Object System.Net.Sockets.TcpClient

    try {
        $client.Connect($IP, $Port)
    } catch {
        Write-Error "Failed to connect to $IP on port $Port"
        return
    }

    if (-not $client.Connected) {
        Write-Error "Failed to connect to $IP on port $Port"
        return
    }

    $stream = $client.GetStream()
    $writer = New-Object System.IO.StreamWriter($stream)
    $reader = New-Object System.IO.StreamReader($stream)
    $writer.AutoFlush = $true
    $writer.Write("{`"command`":`"$Command`"}")
    $writer.Flush()
    Start-Sleep -Milliseconds 100
    $response = $reader.ReadToEnd()
    $client.Close()

    # Output Parse JSON
    $response | ConvertFrom-Json -ErrorAction Stop
}

#######################################################################################################################

function Get-AvalonCustomData {

    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $ApiObject
    )

    $CustomData = $NULL

    #--

    # Avalon Nano 3S
    $CustomDataRAW = $ApiObject.STATS | Where-Object { $NULL -ne $_.'MM ID0' } | Select-Object -ExpandProperty 'MM ID0'

    if ( $NULL -ne $CustomDataRAW ) {

        #Write-Host 'Get-AvalonCustomData | Avalon Nano 3S Pattern Found' -ForegroundColor Green

    } else {

        $CustomDataRAW = $ApiObject.STATS.'MM ID0:Summary'
        $CustomDataRAW = $CustomDataRAW -replace '(\w+):\[([^\]]+)\]', '$1[$2]'

        if ( $NULL -ne $CustomDataRAW ) {

            #Write-Host 'Get-AvalonCustomData | Avalon Q Pattern Found' -ForegroundColor Green

        } else {

            #Write-Host 'Get-AvalonCustomData | CustomDataRAW NOT FOUND !' -ForegroundColor Yellow
        }
    }

    if ( $NULL -ne $CustomDataRAW ) {

        $MatchList = [regex]::Matches($CustomDataRAW, '(\w+)\[([^\]]+)\]')

        # Create a hashtable to store the key-value pairs
        $CustomDataHashTable = [ordered] @{}

        foreach ($match in $MatchList) {
            $key = $match.Groups[1].Value
            $value = $match.Groups[2].Value

            # Handle special cases for values that might contain spaces
            if ($value -match '^\d+$') {
                try {
                    $CustomDataHashTable[$key] = [int]$value
                } catch {
                    $CustomDataHashTable[$key] = [long]$value
                }
            } elseif ($value -match '^\d+\.\d+$') {
                $CustomDataHashTable[$key] = [double]$value
            } else {
                $CustomDataHashTable[$key] = $value
            }
        }

        # Create a custom object from the hashtable
        $CustomData = New-Object PSObject -Property $CustomDataHashTable

        # Sort the properties of the custom object
        $CustomData = $CustomData | Select-Object -Property ( $CustomDataHashTable.Keys | Sort-Object )

    } else {

        #Write-Host 'Get-AvalonCustomData | CustomDataRAW NOT FOUND !' -ForegroundColor Yellow
    }

    #--

    $CustomData
}

#######################################################################################################################

function Get-AvalonMinerInfo {

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

    $MinerInfo = [PSCustomObject] @{
        IP                       = $IP
        Model                    = $NULL
        Status                   = $NULL
        WorkMode                 = $NULL
        MaxPowerOutput           = $NULL
        Uptime                   = $NULL

        FanSpeed_PCT             = $NULL
        Fan1Speed_RPM            = $NULL
        Fan2Speed_RPM            = $NULL
        Fan3Speed_RPM            = $NULL
        Fan4Speed_RPM            = $NULL

        HashRate_Average_THS     = $NULL
        HashRate_Momentary_THS   = $NULL
        HashRate_Current_THS     = $NULL
        HashRate_Measured_THS    = $NULL

        HashRate_CGM_Average_THS = $NULL
        HashRate_CGM_5s_THS      = $NULL
        HashRate_CGM_1m_THS      = $NULL
        HashRate_CGM_5m_THS      = $NULL
        HashRate_CGM_15m_THS     = $NULL

        Temp_CaseInlet           = $NULL
        Temp_HashboardIn         = $NULL
        Temp_HashboardOut        = $NULL
        Temp_AsicTarget          = $NULL
        Temp_AsicAverage         = $NULL
        Temp_AsicMaximum         = $NULL
    }

    #--

    $ESTATS_ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'estats'

    if ( $NULL -eq $ESTATS_ApiObject ) {
        return
    }

    $CustomData = Get-AvalonCustomData -ApiObject $ESTATS_ApiObject

    #--

    # Model

    if ( $NULL -ne $CustomData.Ver ) {
        $MinerInfo.Model = $CustomData.Ver -split '-' | Select-Object -First 1
    }

    # Status

    if ( $NULL -ne $CustomData.SoftOFF ) {
        if ( $CustomData.SoftOFF -gt 0 ) {
            $MinerInfo.Status = 'StandBy'
        } elseif ( $CustomData.SoftOFF -eq 0 ) {
            $MinerInfo.Status = 'Active'
        }
    }

    # Work Mode

    if ( $NULL -ne $CustomData.WORKMODE ) {

        #$MinerInfo.WorkMode = $CustomData.WORKMODE
        # 0 = Low/Eco, 1 = Medium/Standard, 2 = High/Super
        switch ($CustomData.WORKMODE) {
            0 { $MinerInfo.WorkMode = '0 / Low / Eco' }
            1 { $MinerInfo.WorkMode = '1 / Medium / Standard' }
            2 { $MinerInfo.WorkMode = '2 / High / Super' }
            default { $MinerInfo.WorkMode = 'UNDEFINED' }
        }
    }

    # Max Power Output

    if ( $NULL -ne $CustomData.MPO ) {
        $MinerInfo.MaxPowerOutput = $CustomData.MPO
    }

    # Uptime

    if ( $NULL -ne $CustomData.Elapsed ) {
        $Uptime = [TimeSpan]::FromSeconds($CustomData.Elapsed)
        $MinerInfo.Uptime = '{0}d {1}h {2}m {3}s' -f $Uptime.Days, $Uptime.Hours, $Uptime.Minutes, $Uptime.Seconds
    }


    # Hash Rate

    if ( $NULL -ne $CustomData.GHSavg ) {
        $MinerInfo.HashRate_Average_THS = '{0:N2}' -f $($CustomData.GHSavg / 1000)
    }

    if ( $NULL -ne $CustomData.GHSmm ) {
        $MinerInfo.HashRate_Momentary_THS = '{0:N2}' -f $($CustomData.GHSmm / 1000)
    }

    if ( $NULL -ne $CustomData.GHSspd ) {
        $MinerInfo.HashRate_Current_THS = '{0:N2}' -f $($CustomData.GHSspd / 1000)
    }

    if ( $NULL -ne $CustomData.MGHS ) {
        $MinerInfo.HashRate_Measured_THS = '{0:N2}' -f $($CustomData.MGHS / 1000)
    }

    # Fans

    if ( $NULL -ne $CustomData.FanR ) {
        $MinerInfo.FanSpeed_PCT = $( $CustomData.FanR ).Trim('%')
    }

    if ( $NULL -ne $CustomData.Fan1 ) {
        $MinerInfo.Fan1Speed_RPM = $CustomData.Fan1
    }

    if ( $NULL -ne $CustomData.Fan2 ) {
        $MinerInfo.Fan2Speed_RPM = $CustomData.Fan2
    }

    if ( $NULL -ne $CustomData.Fan3 ) {
        $MinerInfo.Fan3Speed_RPM = $CustomData.Fan3
    }

    if ( $NULL -ne $CustomData.Fan4 ) {
        $MinerInfo.Fan4Speed_RPM = $CustomData.Fan4
    }

    # Temperature

    if ( $NULL -ne $CustomData.ITemp ) {
        $MinerInfo.Temp_CaseInlet = $CustomData.ITemp
    }

    if ( $NULL -ne $CustomData.HBITemp ) {
        $MinerInfo.Temp_HashboardIn = $CustomData.HBITemp
    }

    if ( $NULL -ne $CustomData.HBOTemp ) {
        $MinerInfo.Temp_HashboardOut = $CustomData.HBOTemp
    }

    if ( $NULL -ne $CustomData.TarT ) {
        $MinerInfo.Temp_AsicTarget = $CustomData.TarT
    }

    if ( $NULL -ne $CustomData.TAvg ) {
        $MinerInfo.Temp_AsicAverage = $CustomData.TAvg
    }

    if ( $NULL -ne $CustomData.TMax ) {
        $MinerInfo.Temp_AsicMaximum = $CustomData.TMax
    }

    #--

    $SUMMARY_ApiObject = Invoke-AvalonAPI -IP $IP -Port $Port -Command 'summary'

    if ( $NULL -eq $SUMMARY_ApiObject ) {
        return
    }

    if ( $SUMMARY_ApiObject.SUMMARY.'MHS av' ) {
        $MinerInfo.HashRate_CGM_Average_THS = '{0:N2}' -f $($SUMMARY_ApiObject.SUMMARY.'MHS av' / 1000000)
    }
    if ( $SUMMARY_ApiObject.SUMMARY.'MHS 5s' ) {
        $MinerInfo.HashRate_CGM_5s_THS = '{0:N2}' -f $($SUMMARY_ApiObject.SUMMARY.'MHS 5s' / 1000000)
    }
    if ( $SUMMARY_ApiObject.SUMMARY.'MHS 1m' ) {
        $MinerInfo.HashRate_CGM_1m_THS = '{0:N2}' -f $($SUMMARY_ApiObject.SUMMARY.'MHS 1m' / 1000000)
    }
    if ( $SUMMARY_ApiObject.SUMMARY.'MHS 5m' ) {
        $MinerInfo.HashRate_CGM_5m_THS = '{0:N2}' -f $($SUMMARY_ApiObject.SUMMARY.'MHS 5m' / 1000000)
    }
    if ( $SUMMARY_ApiObject.SUMMARY.'MHS 15m' ) {
        $MinerInfo.HashRate_CGM_15m_THS = '{0:N2}' -f $($SUMMARY_ApiObject.SUMMARY.'MHS 15m' / 1000000)
    }

    #--

    $MinerInfo
}

#######################################################################################################################
