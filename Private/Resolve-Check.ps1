function Resolve-Check {
<#
.SYNOPSIS
Resolves configured IISWebFarm checks.
.DESCRIPTION
Expands special values such as 'All', validates
configured checks and returns a unique sorted list.
.PARAMETER Checks
Configured checks from Verify-Settings.psd1.
.INPUTS
[String[]]

Configured checks from Verify-Settings.psd1.
.OUTPUTS
[String[]]

Resolved and validated check names.
Special values such as 'All' are expanded.
Returned values are unique and sorted.
.NOTES
Author      : theQuikest
Version     : 1.1.0.0
Last Updated: 2026-11-26
#>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string[]]
        $Checks
    ) #param

    try {
        Write-Verbose ("Resolving checks.")

        if (-not $Checks)
        {
            throw [System.ArgumentException]::new(
                'Checks collection is empty.'
            )
        } #if

        $SupportedChecks = @(
            'ApplicationPools'
            'DNS'
            'HealthProbe'
            'HTTPS'
            'WebDeploy'
            'Websites'
        )

        Write-Verbose (
            "Configured checks: " +
            ($Checks -join ', ')
        )

        $ResolvedChecks = New-Object `
            System.Collections.Generic.List[string]

        foreach ($Check in $Checks) {
            if ($Check -eq 'All')
            {
                Write-Verbose (
                    "Expanding 'All'."
                )

                $ResolvedChecks.AddRange(
                    $SupportedChecks
                )

                continue
            } #if

            if ($Check -notin $SupportedChecks)
            {
                throw [System.ArgumentException]::new(
                    "Unsupported check '$Check'."
                )
            } #if

            $ResolvedChecks.Add(
                $Check
            )
        } #foreach

        $ResolvedChecks = $ResolvedChecks |
            Sort-Object -Unique

        Write-Verbose (
            "Resolved checks: " +
            ($ResolvedChecks -join ', ')
        )
        
        $ResolvedChecks = @(
            $ResolvedChecks |
                Sort-Object -Unique
        )

        return $ResolvedChecks
    } #try

    catch {
        throw [SettingsValidationException]::new(
            (
                "Failed to resolve checks. " +
                $_.Exception.Message
            ),
            $_.Exception
        )
    } #catch
} #function Resolve-Check