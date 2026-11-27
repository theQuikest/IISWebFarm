BeforeAll
{
    . $PSScriptRoot\..\..\Classes\IISWebFarmExitCode.ps1

    . $PSScriptRoot\..\..\Classes\IISWebFarmException.ps1

    . $PSScriptRoot\..\..\Classes\SettingsValidationException.ps1
    . $PSScriptRoot\..\..\Classes\ConfigurationImportException.ps1

    . $PSScriptRoot\..\..\Private\Import-IISWebFarmSettings.ps1

} #BeforeAll

Describe 'Import-IISWebFarmSettings'
{
    BeforeEach
    {
        $TestRoot = Join-Path `
            -Path $TestDrive `
            -ChildPath 'Config'

        New-Item `
            -Path $TestRoot `
            -ItemType Directory `
            -Force | Out-Null

        $SettingsPath = Join-Path `
            -Path $TestRoot `
            -ChildPath 'Verify-Settings.psd1'

        $MailSettingsPath = Join-Path `
            -Path $TestRoot `
            -ChildPath 'Verify-MailSettings.psd1'

    } #BeforeEach

    It 'Imports both settings files'
    {
        @'
@{
    SchemaVersion = '1.0'
}
'@ | Set-Content `
            -Path $SettingsPath `
            -Encoding UTF8

        @'
@{
    From = 'alerts@example.com'
}
'@ | Set-Content `
            -Path $MailSettingsPath `
            -Encoding UTF8

        $Result = Import-IISWebFarmSettings `
            -SettingsPath $SettingsPath `
            -MailSettingsPath $MailSettingsPath

        $Result |
            Should -Not -BeNullOrEmpty

        $Result.Settings.SchemaVersion |
            Should -Be '1.0'

        $Result.MailSettings.From |
            Should -Be 'alerts@example.com'

    } #it

    It 'Returns original file paths'
    {
        @'
@{}
'@ | Set-Content `
            -Path $SettingsPath

        @'
@{}
'@ | Set-Content `
            -Path $MailSettingsPath

        $Result = Import-IISWebFarmSettings `
            -SettingsPath $SettingsPath `
            -MailSettingsPath $MailSettingsPath

        $Result.SettingsPath |
            Should -Be $SettingsPath

        $Result.MailSettingsPath |
            Should -Be $MailSettingsPath

    } #it

    It 'Throws ConfigurationImportException when settings file is missing'
    {
        @'
@{}
'@ | Set-Content `
            -Path $MailSettingsPath

        {
            Import-IISWebFarmSettings `
                -SettingsPath $SettingsPath `
                -MailSettingsPath $MailSettingsPath

        } | Should -Throw `
            -ExceptionType ConfigurationImportException

    } #it

    It 'Throws ConfigurationImportException when mail settings file is missing'
    {
        @'
@{}
'@ | Set-Content `
            -Path $SettingsPath

        {
            Import-IISWebFarmSettings `
                -SettingsPath $SettingsPath `
                -MailSettingsPath $MailSettingsPath

        } | Should -Throw `
            -ExceptionType ConfigurationImportException

    } #it

    It 'Throws ConfigurationImportException when Verify-Settings.psd1 is invalid'
    {
        'ThisIsNotValidPsd1' |
            Set-Content `
                -Path $SettingsPath

        @'
@{}
'@ | Set-Content `
            -Path $MailSettingsPath

        {
            Import-IISWebFarmSettings `
                -SettingsPath $SettingsPath `
                -MailSettingsPath $MailSettingsPath

        } | Should -Throw `
            -ExceptionType ConfigurationImportException

    } #it

    It 'Throws ConfigurationImportException when Verify-MailSettings.psd1 is invalid'
    {
        @'
@{}
'@ | Set-Content `
            -Path $SettingsPath

        'ThisIsNotValidPsd1' |
            Set-Content `
                -Path $MailSettingsPath

        {
            Import-IISWebFarmSettings `
                -SettingsPath $SettingsPath `
                -MailSettingsPath $MailSettingsPath

        } | Should -Throw `
            -ExceptionType ConfigurationImportException

    } #it

    It 'ConfigurationImportException contains correct exit code'
    {
        $Exception =
            [ConfigurationImportException]::new(
                'Test Message'
            )

        $Exception.ExitCode |
            Should -Be (
                [IISWebFarmExitCode]::ConfigurationImportFailure
            )
    } #it
} #Describe Import-IISWebFarmSetting