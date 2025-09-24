# AvalonPS7

PowerShell 7 Tools for Canaan Avalon BTC Miners

## Why this project

I love Canaan hardware but like someone said `the software has a distinctly hacked together feel`.

Canaan Avalon home miners like the Nano 3S & the Q are built to be managed by a phone using Avalon Family App.

From a computer, I found the following methods:

* Web Interface: Require a QR code to be scan with the phone `Avalon Family App` each time. Basic Info Only.
* FMS Software: Only valid solution, it's old, ugly and shaky at best.
* AvalonMinerViewer: A shady russian software. It is infected with a virus.


The goal of this project is to communicate directly with the miners, skipping Canaan softwares.

* Better MinerInfo
* Multi-Miner Dashboard
* Monitoring (Status, Fans, Temp, Pool, etc.)
* Report JSON, CSV, XSLX
* Discord Bot Alerting
* Remote Control !? I.e. change WorkMode

While staying open source

### Tested/Supported Models:

* Nano 3
* Nano 3S
* Q

## Scripts

All the free tools are written using PowerShell 7.

PowerShell 7 is free and can be installed on Windows, Linux, macOS & more.

[Install PS7](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell)

### Show-AvalonMinerInfo

```powershell
PS C:\GIT\AvalonPS7> .\Show-AvalonMinerInfo.ps1 -IP 192.168.1.236

```

## Avalon Download

[FMS Repository](https://download.canaan-creative.com/fms/)

