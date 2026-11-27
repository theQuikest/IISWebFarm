function Resolve-WebDeployInstallation {

<#
.SYNOPSIS
Resolves Web Deploy installation information.

.DESCRIPTION
Retrieves Web Deploy installation details from the
local or remote computer.

The function validates that:

* The Web Deploy registry key exists
* An installation path is configured
* msdeploy.exe exists

The function returns installation metadata that
can be reused by other IISWebFarm functions.

.OUTPUTS
[PSCustomObject]

.NOTES
Author      : JP Kuipers
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

        $WebDeploy = Invoke-Command `
            -ComputerName $ComputerName `
            -ScriptBlock {

                $RegistryKey = Get-ItemProperty `
                    'HKLM:\SOFTWARE\Microsoft\IIS Extensions\MSDeploy\3' `
                    -ErrorAction Stop

                $ExecutablePath = Join-Path `
                    $RegistryKey.InstallPath `
                    'msdeploy.exe'

                [PSCustomObject]@{

                    ComputerName = $env:COMPUTERNAME

                    Installed = $RegistryKey.Install -eq 1

                    Version = $RegistryKey.Version

                    InstallPath = $RegistryKey.InstallPath

                    ExecutablePath = $ExecutablePath

                    ExecutableExists = (
                        Test-Path `
                            -Path $ExecutablePath
                    )

                } #PSCustomObject

            } `
            -ErrorAction Stop

        return $WebDeploy

    } #PROCESS

} #function Resolve-WebDeployInstallation