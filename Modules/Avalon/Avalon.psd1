
@{

    ModuleVersion     = '1.2.0'
    GUID              = 'C195AD55-8B68-4181-9850-49D273E68328'
    Author            = 'Gr33nDrag0n'
    CompanyName       = ''
    Copyright         = 'Copyright (c) 2025 Gr33nDrag0n69 | SPDX-License-Identifier: Apache-2.0'
    PowerShellVersion = '7.3'
    RootModule        = 'Avalon.psm1'

    # For best performance, do not use wildcards and do not delete the entry, use an empty array if there are nothing to export.

    FunctionsToExport = @(
        'Invoke-AvalonAPI',
        'Get-AvalonCustomData',
        'Get-AvalonMinerInfo',
        'Convert-AvalonDifficulty',
        'Format-AvalonMinerMacAddress'
    )
    CmdletsToExport   = @()
    VariablesToExport = ''
    AliasesToExport   = @()
}