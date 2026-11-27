function Test-ModuleRequirements {
<#
.SYNOPSIS
Validates IISWebFarm prerequisites.
.DESCRIPTION
Validates all servers configured for IISWebFarm.

The function verifies:

* WinRM connectivity
* Supported operating system
* Supported PowerShell version
* IIS installation
* W3SVC service state
* WebAdministration module
* Web Deploy installation

All failures are collected and returned in a
single execution.

If one or more servers fail validation a bootstrap
failure log is written and execution terminates.
.OUTPUTS
[IISWebFarmRequirementResult[]]
#>
    [CmdletBinding()]
    param (

        [Parameter()]
        [string[]]
        $ComputerName = $env:COMPUTERNAME
    ) #param

    BEGIN {
        $Results = New-Object `
            System.Collections.Generic.List[
                IISWebFarmRequirementResult
            ]
    } #BEGIN

    PROCESS {
        foreach ($Server in $ComputerName)
        {
            Write-Verbose (
                "Validating [$Server]."
            )

            $Result = :new()

            $Result.ComputerName = $Server

            $Result.Passed = $true

            # WinRM

            try {
                Test-WSMan `
                    -ComputerName $Server `
                    -ErrorAction Stop `
                | Out-Null

                $Result.WinRMAvailable = $true

            }
            catch {
                $Result.WinRMAvailable = $false

                $Result.Passed = $false

                $Result.FailureReasons += (
                    "WinRM unavailable. " +
                    $_.Exception.Message
                )

                $Results.Add($Result)

                continue
            } #catch

            # Operating System

            try {
                $OperatingSystem =
                    Invoke-Command `
                        -ComputerName $Server `
                        -ScriptBlock {
                            Get-CimInstance `
                                Win32_OperatingSystem
                        } `
                        -ErrorAction Stop

                $Result.OperatingSystem =
                    $OperatingSystem.Caption

                if (
                    [int]$OperatingSystem.BuildNumber -lt 17763
                )
                {
                    $Result.Passed = $false

                    $Result.FailureReasons += (
                        'Windows Server 2019 or later ' +
                        'is required.'
                    )
                } #if
            }
            catch {
                $Result.Passed = $false

                $Result.FailureReasons += (
                    'Operating System validation failed.'
                )

            } #catch

            # PowerShell

            try {
                $Version =
                    Invoke-Command `
                        -ComputerName $Server `
                        -ScriptBlock {
                            $PSVersionTable.PSVersion
                        } `
                        -ErrorAction Stop

                $Result.PowerShellVersion =
                    [version]$Version

                if ($Version -lt [version]'5.1')
                {
                    $Result.Passed = $false

                    $Result.FailureReasons += (
                        'PowerShell 5.1 or later is required.'
                    )
                } #if
            }
            catch {
                $Result.Passed = $false

                $Result.FailureReasons += (
                    'PowerShell validation failed.'
                )
            } #catch

            # IIS

            try {
                $Result.IISInstalled =
                    Invoke-Command `
                        -ComputerName $Server `
                        -ScriptBlock {
                            (
                                Get-WindowsFeature `
                                    -Name Web-Server
                            ).Installed
                        } `
                        -ErrorAction Stop

                if (-not $Result.IISInstalled)
                {
                    $Result.Passed = $false

                    $Result.FailureReasons += (
                        'IIS is not installed.'
                    )
                } #if
            }
            catch {
                $Result.Passed = $false

                $Result.FailureReasons += (
                    'IIS validation failed.'
                )
            } #catch

            # W3SVC

            try {
                $Result.W3SVCRunning =
                    Invoke-Command `
                        -ComputerName $Server `
                        -ScriptBlock {
                            (
                                Get-Service `
                                    -Name W3SVC
                            ).Status -eq 'Running'
                        } `
                        -ErrorAction Stop

                if (-not $Result.W3SVCRunning)
                {
                    $Result.Passed = $false

                    $Result.FailureReasons += (
                        'W3SVC service is not running.'
                    )
                } #if
            }
            catch {
                $Result.Passed = $false

                $Result.FailureReasons += (
                    'W3SVC validation failed.'
                )
            } #catch

            # WebAdministration

            try {
                $Result.WebAdministrationAvailable =
                    Invoke-Command `
                        -ComputerName $Server `
                        -ScriptBlock {
                            $null -ne (
                                Get-Module `
                                    -ListAvailable `
                                    -Name WebAdministration
                            )
                        } `
                        -ErrorAction Stop

                if (
                    -not $Result.WebAdministrationAvailable
                )
                {
                    $Result.Passed = $false

                    $Result.FailureReasons += (
                        'WebAdministration module not found.'
                    )
                } #if
            }
            catch {
                $Result.Passed = $false

                $Result.FailureReasons += (
                    'WebAdministration validation failed.'
                )

            } #catch

            # Web Deploy

            try {
                $WebDeploy =
                    Resolve-WebDeployInstallation `
                        -ComputerName $Server

                $Result.WebDeployVersion =
                    [version]$WebDeploy.Version

                $Result.WebDeployPath =
                    $WebDeploy.ExecutablePath

                if (-not $WebDeploy.Installed)
                {
                    $Result.Passed = $false

                    $Result.FailureReasons += (
                        'Web Deploy is not installed.'
                    )
                } #if

                if (-not $WebDeploy.ExecutableExists)
                {
                    $Result.Passed = $false

                    $Result.FailureReasons += (
                        'msdeploy.exe not found.'
                    )
                } #if

                if (
                    [version]$WebDeploy.Version `
                        -lt `
                    [version]'4.0'
                )
                {
                    $Result.Passed = $false

                    $Result.FailureReasons += (
                        'Web Deploy 4.0 or later is required.'
                    )
                } #if

            }
            catch {
                $Result.Passed = $false

                $Result.FailureReasons += (
                    'Web Deploy validation failed.'
                )
            } #catch

            $Results.Add($Result)
        } #foreach
    } #PROCESS

    END {
        $FailedResults = $Results |
            Where-Object Passed -eq $false

        if ($FailedResults)
        {
            # Bootstrap logging
            # TODO

            Write-Host (
                'IISWebFarm requirements validation failed.'
            ) -ForegroundColor Red

            throw :new(
                (
                    'One or more servers failed ' +
                    'module requirements validation.'
                )
            )
        } #if

        return $Results
    } #END
} #function Test-ModuleRequirements