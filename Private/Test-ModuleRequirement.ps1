function Test-ModuleRequirements {
<#
.SYNOPSIS
Validates IISWebFarm module requirements.
.DESCRIPTION
Validates all target servers against the minimum
requirements required by IISWebFarm.

The function validates:

* WinRM connectivity
* Windows Server operating system requirements
* PowerShell version requirements
* IIS installation
* W3SVC service status
* WebAdministration module availability
* Web Deploy installation and version requirements

All specified servers are evaluated. Validation
failures are collected and reported together.

If one or more servers fail validation, a bootstrap
failure log is written and the validation results
are displayed to the console.
.PARAMETER ComputerName
One or more target servers to validate.
.INPUTS
[String[]]
.OUTPUTS
[IISWebFarmRequirementResult[]]
.NOTES
Author      : theQuikest
Version     : 1.1.0.0
Last Updated: 2026-11-27
#>
    
[CmdletBinding(
    SupportsShouldProcess = $true,
    ConfirmImpact = 'Low'
)]
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
    foreach ($Server in $ComputerName) {
        Write-Verbose ("Validating requirements on [$Server].")

        $Result = [IISWebFarmRequirementResult]::new()

        $Result.ComputerName = $Server

        Write-Verbose ("Testing WinRM connectivity.")

        try {
            Test-WSMan `
                -ComputerName $Server `
                -ErrorAction Stop `
            | Out-Null

            $Result.WinRMAvailable = $true

            Write-Verbose ("WinRM validation succeeded.")
        } #try
        catch {
            $Result.WinRMAvailable = $false

            $Result.Passed = $false

            $Result.FailureReasons += (

                "WinRM unavailable. " +

                $_.Exception.Message
            )

            $Results += $Result

            Write-Verbose ("WinRM validation failed on [$Server].")

            continue
        } #catch

        Write-Verbose ("Testing operating system requirements.")

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

            Write-Verbose ("Operating system detected: $($OperatingSystem.Caption).")

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

            Write-Verbose ("Operating system validation succeeded.")
        } #try
        catch {
            $Result.FailureReasons += (
                'Operating System validation failed. ' +

                $_.Exception.Message
            )
        } #catch

        Write-Verbose ("Testing PowerShell version.")

        try {
            $Version = Invoke-Command `
                -ComputerName $Server `
                -ScriptBlock {
                    $PSVersionTable.PSVersion
                } `
                -ErrorAction Stop

            $Result.PowerShellVersion =
                [version]$Version

            Write-Verbose ("PowerShell version detected: $Version.")

            if (
                $Version -lt [version]'5.1'
            )
            {
                $Result.FailureReasons += (
                    'PowerShell 5.1 or later is required.'
                )
            } #if

            Write-Verbose ("PowerShell validation succeeded.")
        } #try
        catch {
            $Result.FailureReasons += (
                'PowerShell validation failed. ' +

                $_.Exception.Message
            )
        } #catch

        Write-Verbose ("Testing IIS installation.")

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

            Write-Verbose ("IIS validation succeeded.")
        } #try
        catch {
            $Result.FailureReasons += (

                'IIS validation failed. ' +

                $_.Exception.Message
            )
        } #catch

        Write-Verbose ("Testing W3SVC service.")

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

            Write-Verbose ("W3SVC validation succeeded.")
        } #try
        catch {
            $Result.FailureReasons += (
                'W3SVC validation failed. ' +

                $_.Exception.Message
            )
        } #catch

        Write-Verbose ("Testing WebAdministration module.")

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

            Write-Verbose ("WebAdministration validation succeeded.")
        } #try
        catch {
            $Result.FailureReasons += (

                'WebAdministration validation failed. ' +

                $_.Exception.Message
            )
        } #catch

        Write-Verbose ("Testing Web Deploy installation.")

        try {
            $WebDeploy =
                Resolve-WebDeployInstallation `
                    -ComputerName $Server

            Write-Verbose ("Web Deploy version detected: $($WebDeploy.Version).")

            Write-Verbose ("Web Deploy executable: $($WebDeploy.ExecutablePath).")

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

            Write-Verbose ("Web Deploy validation succeeded.")
        } #try
        catch {
            $Result.FailureReasons += (

                'Web Deploy validation failed. ' +

                $_.Exception.Message
            )
        } #catch

        Write-Verbose ("Validation completed for [$Server].")

        # Final Result

        $Result.Passed =
            ($Result.FailureReasons.Count -eq 0)

        if ($Result.Passed)
        {
            Write-Verbose ("All requirements satisfied on [$Server].")
        }
        else
        {
            Write-Verbose ("One or more requirements failed on [$Server].")
        } #if

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
        Write-Verbose ("Tests failed, creating bootstrap log file")
        $Timestamp = Get-Date `
            -Format 'yyyy-MM-dd_HHmmss'`

        $BootstrapLogFile = Join-Path `
            -Path 'C:\' `
            -ChildPath (
                "BootstrapFailure_$Timestamp.log"
            )

        $LogContent = @()

        $LogContent += (
            'IISWebFarm Bootstrap Validation Failure'
        )

        $LogContent += (
            "Generated : $(
                Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
            )"
        )

        $LogContent += ''

        foreach ($FailedResult in $FailedResults)
        {
            $LogContent += (
                "Server : $($FailedResult.ComputerName)"
            )

            foreach ($Reason in $FailedResult.FailureReasons)
            {
                $DisplayReason = $Reason

                if (
                    $DisplayReason -match
                    '<f:Message>(.*?)</f:Message>'
                )
                {
                    $DisplayReason =
                        $DisplayReason -replace
                        '<f:WSManFault.*?<f:Message>',
                        ''

                    $DisplayReason =
                        $DisplayReason -replace
                        '</f:Message>.*',
                        ''
                } #if

                $LogContent += (
                    " - $DisplayReason"
                )
            } #foreach

            $LogContent += ''
        } #foreach

        if (
            $PSCmdlet.ShouldProcess(
                $BootstrapLogFile,
                'Create bootstrap failure log'
            )
        )
        {
            $LogContent |
                Set-Content `
                    -Path $BootstrapLogFile `
                    -Encoding UTF8
        } #if

        Write-Host ("")
        Write-Host ('IISWebFarm requirements validation failed.') -ForegroundColor Yellow

        foreach ($FailedResult in $FailedResults)
        {
            Write-Host ("")
            Write-Host ("Server: $($FailedResult.ComputerName)") -ForegroundColor Yellow

            foreach ($Reason in $FailedResult.FailureReasons)
            {
                $DisplayReason = $Reason

                if (
                    $DisplayReason -match
                    '<f:Message>(.*?)</f:Message>'
                )
                {
                    $DisplayReason =
                        $DisplayReason -replace
                        '<f:WSManFault.*?<f:Message>',
                        ''

                    $DisplayReason =
                        $DisplayReason -replace
                        '</f:Message>.*',
                        ''
                } #if

                Write-Host (" - $DisplayReason")
            } #foreach
        } #foreach

        Write-Host ("")
        if ($WhatIfPreference)
        {
            Write-Host ("Bootstrap log would be written to: $BootstrapLogFile") -ForegroundColor Yellow
        }
        else
        {
            Write-Host ("What if: Bootstrap log written to: $BootstrapLogFile") -ForegroundColor Yellow
        }

        return
    } #if

    return $Results
} #END
} #function Test-ModuleRequirements