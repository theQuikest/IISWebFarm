function Test-ModuleRequirements {
<#
.SYNOPSIS
Validates IISWebFarm module requirements.
.DESCRIPTION
Validates all servers against the minimum
requirements needed by IISWebFarm.

The function tests:

* WinRM connectivity
* Windows Server version
* PowerShell version
* IIS installation
* W3SVC status
* WebAdministration availability
* Web Deploy installation

All servers are evaluated and all failures are
collected before execution stops.
.OUTPUTS
[IISWebFarmRequirementResult[]]
.NOTES
Author      : theQuikest
Version     : 1.1.0.0
Last Updated: 2026-11-27
#>
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]
        $ComputerName = $env:COMPUTERNAME
    ) #param

    BEGIN {
        Write-Verbose ("Initializing requirement validation.")

        # Minimum supported Windows Server build.
        # Build 17763 equals Windows Server 2019.
        # Defined as a constant for easier future maintenance.
        [int]$MinimumBuildNumber = 17763

        # This setting checks if the OS is a Windows Server version
        # IISWebFarm supports Windows Server only.
        # Set to $false for development or lab environments.
        # Adjust the build number to 
        $RequireServerOperatingSystem = $true

        $Results = @()
    } #BEGIN

    PROCESS {
        foreach ($Server in $ComputerName)
        {
            Write-Verbose ("Validating requirements on [$Server].")

            $Result = [IISWebFarmRequirementResult]::new()

            $Result.ComputerName = $Server

        # WinRM
    
            try {
                Test-WSMan `
                    -ComputerName $Server `
                    -ErrorAction Stop `
                | Out-Null

                $Result.WinRMAvailable = $true
            } #try
            catch {
                $Result.WinRMAvailable = $false
                $Result.Passed = $false

                $Result.FailureReasons += (
                    "WinRM unavailable. " +
                    $_.Exception.Message
                )

                $Results += $Result

                Write-Verbose (
                    "WinRM validation failed on [$Server]."
                )

                continue

            } #catch

        # Operating System

            try {
                $OperatingSystem = Invoke-Command `
                    -ComputerName $Server `
                    -ScriptBlock {
                        Get-CimInstance `
                            -ClassName Win32_OperatingSystem
                    } `
                    -ErrorAction Stop

                $Result.OperatingSystem =
                $OperatingSystem.Caption

                if ($RequireServerOperatingSystem)
                    {
                        if ($OperatingSystem.ProductType -notin @(2,3))
                            {
                                $Result.FailureReasons += (
                                    'A Windows Server operating system is required.'
                                )
                        } #if
                } #if

                if ([int]$OperatingSystem.BuildNumber -lt $MinimumBuildNumber)
                {
                    $Result.FailureReasons += (
                        'Windows Server 2019 or later is required.'
                    )
                } #if
            } #try
            catch {
                $Result.FailureReasons += (
                    'Operating System validation failed.' +
                    $_.Exception.Message
                )
            } #catch

        # PowerShell
            
            try {
                $Version = Invoke-Command `
                    -ComputerName $Server `
                    -ScriptBlock {

                        $PSVersionTable.PSVersion
                    } `
                    -ErrorAction Stop

                $Result.PowerShellVersion =
                    [version]$Version

                if (
                    $Version -lt [version]'5.1'
                )
                {
                    $Result.FailureReasons += (
                        'PowerShell 5.1 or later is required.'
                    )
                } #if
            } #try
            catch {
                $Result.FailureReasons += (
                    'PowerShell validation failed.' +
                    $_.Exception.Message
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
                    $Result.FailureReasons += (
                        'IIS is not installed.'
                    )
                } #if
            } #try
            catch {
                $Result.FailureReasons += (
                    'IIS validation failed. ' +
                    $_.Exception.Message
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
                    $Result.FailureReasons += (
                        'W3SVC service is not running.'
                    )
                } #if
            } #try
            catch {
                $Result.FailureReasons += (
                    'W3SVC validation failed.' +
                    $_.Exception.Message
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
                    $Result.FailureReasons += (
                        'WebAdministration module not found.'
                    )
                } #if
            } #try
            catch {
                $Result.FailureReasons += (
                    'WebAdministration validation failed.' +
                    $_.Exception.Message
                )
            } #catch

        # Web Deploy

            try {
                $WebDeploy =
                    Resolve-WebDeployInstallation `
                        -ComputerName $Server

                if ($WebDeploy.Version)
                    {
                        $Result.WebDeployVersion =
                            [version]$WebDeploy.Version
                } #if

                if ($WebDeploy.ExecutablePath)
                    {
                        $Result.WebDeployPath =
                            $WebDeploy.ExecutablePath
                } #if

                if (-not $WebDeploy.Installed)
                    {
                        $Result.FailureReasons += (
                            'Web Deploy is not installed.'
                        )
                } #if

                if (-not $WebDeploy.ExecutableExists)
                    {
                        $Result.FailureReasons += (
                            'msdeploy.exe not found.'
                        )
                    } #if

                if (
                    $Result.WebDeployVersion -and
                    $Result.WebDeployVersion -lt [version]'4.0'
                )
                {
                    $Result.FailureReasons += (
                        'Web Deploy 4.0 or later is required.'
                    )
                } #if
            } #try
            catch {
                $Result.FailureReasons += (
                    'Web Deploy validation failed.' +
                    $_.Exception.Message
                )
            } #catch

        # Final Result

            $Result.Passed =
                ($Result.FailureReasons.Count -eq 0)

            $Results += $Result
        } #foreach
    } #PROCESS

    END {
        $FailedResults = @(
            $Results |
            Where-Object Passed -eq $false
        )

        if ($FailedResults.Count -gt 0)
        {
            #
            # TODO:
            # Bootstrap failure logging.
            #

            throw [SettingsValidationException]::new(
                'One or more servers failed module requirements validation.'
            )
        } #if

        return $Results
    } #END
} #function Test-ModuleRequirements