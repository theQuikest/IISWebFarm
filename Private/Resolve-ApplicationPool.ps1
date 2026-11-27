function Resolve-ApplicationPool {
<#
.SYNOPSIS
Retrieves IIS Application Pool information.

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