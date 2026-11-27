function Resolve-ApplicationPool {
<#
.SYNOPSIS
Retrieves IIS Application Pool information.
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

                Get-ChildItem `
                    IIS:\AppPools | ForEach-Object {
                    [PSCustomObject]@{
                        ComputerName =
                            $env:COMPUTERNAME

                        Name =
                            $_.Name

                        State =
                            $_.state

                        ManagedRuntimeVersion =
                            $_.managedRuntimeVersion

                        ManagedPipelineMode =
                            $_.managedPipelineMode

                        StartMode =
                            $_.startMode

                        AutoStart =
                            $_.autoStart

                        IdentityType =
                            $_.processModel.identityType

                        UserName =
                            $_.processModel.userName
                    } #PSCustomObject
                } #foreach
            } `
            -ErrorAction Stop
    } #PROCESS
} #function Resolve-ApplicationPool