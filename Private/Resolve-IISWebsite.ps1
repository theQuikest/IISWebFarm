function Resolve-IISWebsite {
<#
.SYNOPSIS
Retrieves IIS website information.

.OUTPUTS
[PSCustomObject]
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