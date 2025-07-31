
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
    $client.Connect($IP, $Port)

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
