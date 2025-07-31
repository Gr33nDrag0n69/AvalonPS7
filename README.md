# AvalonPS7


## Why this project

Canaan Avalon home miners are built to be managed by android using Avalon Family App.

From a computer, I found the following methods:

* Web Interface: Require a QR code to be scan with the `Avalon Family App` each time. Not much more info available.
* FMS Software: Only valid solution, it's old/ugly and shaky. Bare minimum from Avalon for multi miners management.
* AvalonMinerViewer: A shady russian software. It is infected with a virus.

The goal of this project is to communicate directly with the Nano 3S & Q miners from PowerShell 7 using open source code.

Allowing a nicer and more complete tool to show current miner info and opening more advanced management and monitoring of the Avalon miners.

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

