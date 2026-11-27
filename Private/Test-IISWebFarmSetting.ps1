function Test-IISWebFarmSetting {
<#
.SYNOPSIS
Validates IISWebFarm configuration settings.
.DESCRIPTION
Validates the imported Verify and Mail settings
before execution continues.
.PARAMETER Settings
Settings object returned by
Import-IISWebFarmSettings.
.INPUTS
[IISWebFarmSettings]
.OUTPUTS
[IISWebFarmValidationResult]
Validation result containing errors,
warnings and overall configuration state.
.NOTES
Author      : theQuikest
Version     : 1.1.0.0
Last Updated: 2026-11-26
#>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [pscustomobject]
        $Settings
    ) #param

    try {
        Write-Verbose ("Validating IISWebFarm settings.")

        #
        # Root objects
        #
        if (-not $Settings.Settings)
        {
            throw [System.ArgumentException]::new(
                'Settings section is missing.'
            )
        } #if

        if (-not $Settings.MailSettings)
        {
            throw [System.ArgumentException]::new(
                'MailSettings section is missing.'
            )
        } #if

        #
        # SchemaVersion
        #
        if (-not $Settings.Settings.ContainsKey(
            'SchemaVersion'))
        {
            throw [System.ArgumentException]::new(
                'SchemaVersion is missing.'
            )
        } #if

        if ($Settings.Settings.SchemaVersion -ne '1.0')
        {
            throw [System.ArgumentException]::new(
                (
                    "Unsupported SchemaVersion " +
                    "'$($Settings.Settings.SchemaVersion)'."
                )
            )
        } #if

        #
        # Logging
        #
        if (-not $Settings.Settings.Logging)
        {
            throw [System.ArgumentException]::new(
                'Logging section is missing.'
            )
        } #if

        if (-not $Settings.Settings.Logging.LogRoot)
        {
            throw [System.ArgumentException]::new(
                'Logging.LogRoot is missing.'
            )
        } #if

        if (
            $Settings.Settings.Logging.RetentionDays -lt 1
        )
        {
            throw [System.ArgumentException]::new(
                'Logging.RetentionDays must be greater than zero.'
            )
        } #if

        #
        # Health Probe
        #
        if (-not $Settings.Settings.HealthProbe)
        {
            throw [System.ArgumentException]::new(
                'HealthProbe section is missing.'
            )
        } #if

        if (-not $Settings.Settings.HealthProbe.Path)
        {
            throw [System.ArgumentException]::new(
                'HealthProbe.Path is missing.'
            )
        } #if

        #
        # Checks
        #
        if (-not $Settings.Settings.Checks)
        {
            throw [System.ArgumentException]::new(
                'Checks section is missing.'
            )
        } #if

        #
        # Mail Settings
        #
        if (-not $Settings.MailSettings.From)
        {
            throw [System.ArgumentException]::new(
                'MailSettings.From is missing.'
            )
        } #if

        if (-not $Settings.MailSettings.To)
        {
            throw [System.ArgumentException]::new(
                'MailSettings.To is missing.'
            )
        } #if

        if (-not $Settings.MailSettings.Server)
        {
            throw [System.ArgumentException]::new(
                'MailSettings.Server is missing.'
            )
        } #if

        Write-Verbose ('Settings validation successful.')

        return $Settings
    } #try

    catch {
        throw [SettingsValidationException]::new(
            (
                'Configuration validation failed. ' +
                $_.Exception.Message
            ),
            $_.Exception
        )
    } #catch
} #function Test-IISWebFarmSetting