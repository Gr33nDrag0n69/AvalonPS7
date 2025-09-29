# AvalonPS7

PowerShell 7 Tools for Canaan Avalon BTC Miners

## Why this project

I love Canaan hardware but like someone said `the software has a distinctly hacked together feel`.

Canaan Avalon home miners like the Nano 3/3S & the Q are built to be managed by a phone using Avalon Family App.

From a computer, I found the following methods:

* Web Interface: Require a QR code to be scan with the phone `Avalon Family App` each time. Basic Info Only.
* FMS Software: Only valid solution, it's old, ugly and shaky at best.
* AvalonMinerViewer: A shady russian software. It is infected with a virus.

The goal of this project is to communicate directly with the miners, skipping Canaan softwares.

### Tested/Supported Models:

* Nano 3
* Nano 3S
* Q

## Toolset Documentation

The full documentation on how to use this toolset is [here](./MD/TOOLSET_DOC.md)

### Main Scripts

* [Show-AvalonMinerInfo](./MD/TOOLSET_DOC.md#Show-AvalonMinerInfo)

### HW Config Scripts

* [Set-AvalonMinerFanSpeed](./MD/TOOLSET_DOC.md#Set-AvalonMinerFanSpeed)

### Pool(s) Scripts

* [Show-AvalonMinerPoolConfig](./MD/TOOLSET_DOC.md#Show-AvalonMinerPoolConfig)
* [Set-AvalonMinerPoolConfig](./MD/TOOLSET_DOC.md#Set-AvalonMinerPoolConfig)
* [Set-AvalonMinerActivePool](./MD/TOOLSET_DOC.md#Set-AvalonMinerActivePool)
* [Enable-AvalonMinerPool](./MD/TOOLSET_DOC.md#Enable-AvalonMinerPool)
* [Disable-AvalonMinerPool](./MD/TOOLSET_DOC.md#Disable-AvalonMinerPool)
* [Set-AvalonMinerPoolPriority](./MD/TOOLSET_DOC.md#Set-AvalonMinerPoolPriority)

## External References

* https://github.com/Canaan-Creative/Avalon_Nano3s/blob/master/cg_miner/api/api.c
* https://github.com/Canaan-Creative/Avalon_Nano3s/blob/master/cg_miner/cgminer/driver-avalon.c
* https://github.com/Canaan-Creative/avalon10-docs/blob/master/Universal%20API/Avalon%20A10%20API%20manual-EN.md

## License

This project is licensed under the Apache License 2.0 — see the [LICENSE](./LICENSE) file for details.
SPDX-License-Identifier: Apache-2.0

