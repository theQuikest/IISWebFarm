function Resolve-IISWebsite {
<#
.SYNOPSIS
Retrieves IIS website information.
.OUTPUTS
[PSCustomObject]
.NOTES
Author      : theQuikest
Version     : 1.1.0.0
Last Updated: 2026-11-26
#>

    [CmdletBinding()]
    param (

        [Parameter()]
        [string]
        $ComputerName = $env:COMPUTERNAME
    ) #param

    PROCESS {
        Invoke-Command `
            -ComputerName $ComputerName `
            -ScriptBlock {

                Import-Module `
                    WebAdministration `
                    -ErrorAction Stop

                Get-Website |
                    Select-Object `
                        @{ Name = 'ComputerName'
                           Expression = { $env:COMPUTERNAME } },
                        Name,
                        Id,
                        State,
                        PhysicalPath,
                        ApplicationPool

            } `
            -ErrorAction Stop
    } #PROCESS
} #function Resolve-IISWebsite