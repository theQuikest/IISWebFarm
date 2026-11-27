function Import-IISWebFarmSetting {
<#
.SYNOPSIS
Imports IISWebFarm configuration files.
.DESCRIPTION
Imports the Verify and Mail settings files and returns
their contents as a single object.
.PARAMETER SettingsPath
Path to Verify-Settings.psd1.
.PARAMETER MailSettingsPath
Path to Verify-MailSettings.psd1.
.OUTPUTS
[IISWebFarmSettings]
Combined IISWebFarm configuration object loaded from
Verify-Settings.psd1 and Verify-MailSettings.psd1.
.NOTES
Author      : theQuikest
Version     : 1.1.0.0
Last Updated: 2026-11-26
#>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $SettingsPath,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $MailSettingsPath
    ) #param

    try {
        Write-Verbose ("Importing IISWebFarm settings.")

        #
        # Verify settings file.
        #
        if (-not (Test-Path -Path $SettingsPath))
        {
            throw [System.IO.FileNotFoundException]::new(
                "Settings file not found.",
                $SettingsPath
            )
        } #if

        Write-Verbose ("Importing settings file.")
        Write-Verbose ("Path = $SettingsPath")

        $Settings = Import-PowerShellDataFile `
            -Path $SettingsPath `
            -ErrorAction Stop

        #
        # Mail settings file.
        #
        if (-not (Test-Path -Path $MailSettingsPath))
        {
            throw [System.IO.FileNotFoundException]::new(
                "Mail settings file not found.",
                $MailSettingsPath
            )
        } #if

        Write-Verbose ("Importing mail settings file.")
        Write-Verbose ("Path = $MailSettingsPath")

        $MailSettings = Import-PowerShellDataFile `
            -Path $MailSettingsPath `
            -ErrorAction Stop

        return [PSCustomObject]@{
            Settings         = $Settings

            MailSettings     = $MailSettings

            SettingsPath     = $SettingsPath

            MailSettingsPath = $MailSettingsPath
        }
    } #try

    catch {
        throw [SettingsValidationException]::new(
            (
                "Failed to import IISWebFarm settings. " +
                "SettingsPath='$SettingsPath'. " +
                "MailSettingsPath='$MailSettingsPath'."
            ),
            $_.Exception
        )
    } #catch
} #function Import-IISWebFarmSetting