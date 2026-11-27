BeforeAll {
    . $PSScriptRoot\..\..\Classes\IISWebFarmExitCode.ps1

    . $PSScriptRoot\..\..\Classes\IISWebFarmException.ps1

    . $PSScriptRoot\..\..\Classes\SettingsValidationException.ps1

    . $PSScriptRoot\..\..\Private\Test-IISWebFarmSettings.ps1
} #BeforeAll

Describe 'Test-IISWebFarmSettings' {
    BeforeEach {
        $Settings = [PSCustomObject]@{
            Settings = @{
                SchemaVersion = '1.0'

                Logging = @{
                    LogRoot = 'C:\Deploy\Logs'

                    RetentionDays = 30
                }

                HealthProbe = @{

                    Path = '/health'
                }

                Checks = @(
                    'HealthProbe'
                )
            }

            MailSettings = @{
                From   = 'alerts@example.com'

                To     = 'admin@example.com'

                Server = 'mail.example.com'
            }
        }
    } #BeforeEach

    It 'Returns the original settings object when valid' {
        $Result = Test-IISWebFarmSettings `
            -Settings $Settings

        $Result |
            Should -Not -BeNullOrEmpty

        $Result |
            Should -Be $Settings
    } #it

    $InvalidConfigurations = @(
        @{
            Name            = 'Settings section missing'
            PropertyPath    = 'Settings'
        }

        @{
            Name            = 'MailSettings section missing'
            PropertyPath    = 'MailSettings'
        }
    )

    It '<Name>' -ForEach $InvalidConfigurations {
        $BrokenSettings = $Settings.PSObject.Copy()

        $BrokenSettings.$PropertyPath = $null

        {
            Test-IISWebFarmSettings `
                -Settings $BrokenSettings

        } | Should -Throw `
            -ExceptionType SettingsValidationException
    } #it

    It 'Throws when SchemaVersion is missing' {
        $Settings.Settings.Remove(
            'SchemaVersion'
        )

        {
            Test-IISWebFarmSettings `
                -Settings $Settings

        } | Should -Throw `
            -ExceptionType SettingsValidationException
    } #it

    It 'Throws when SchemaVersion is unsupported' {
        $Settings.Settings.SchemaVersion = '999.0'

        {
            Test-IISWebFarmSettings `
                -Settings $Settings

        } | Should -Throw `
            -ExceptionType SettingsValidationException
    } #it

    It 'Throws when Logging section is missing' {
        $Settings.Settings.Remove(
            'Logging'
        )

        {
            Test-IISWebFarmSettings `
                -Settings $Settings

        } | Should -Throw `
            -ExceptionType SettingsValidationException
    } #it

    It 'Throws when Logging.LogRoot is missing' {
        $Settings.Settings.Logging.Remove(
            'LogRoot'
        )

        {
            Test-IISWebFarmSettings `
                -Settings $Settings

        } | Should -Throw `
            -ExceptionType SettingsValidationException
    } #it

    It 'Throws when RetentionDays is less than one' {
        $Settings.Settings.Logging.RetentionDays = 0

        {
            Test-IISWebFarmSettings `
                -Settings $Settings

        } | Should -Throw `
            -ExceptionType SettingsValidationException
    } #it

    It 'Throws when HealthProbe section is missing' {
        $Settings.Settings.Remove(
            'HealthProbe'
        )

        {
            Test-IISWebFarmSettings `
                -Settings $Settings

        } | Should -Throw `
            -ExceptionType SettingsValidationException
    } #it

    It 'Throws when HealthProbe.Path is missing' {
        $Settings.Settings.HealthProbe.Remove(
            'Path'
        )

        {
            Test-IISWebFarmSettings `
                -Settings $Settings

        } | Should -Throw `
            -ExceptionType SettingsValidationException
    } #it

    It 'Throws when Checks section is missing' {
        $Settings.Settings.Remove(
            'Checks'
        )

        {
            Test-IISWebFarmSettings `
                -Settings $Settings

        } | Should -Throw `
            -ExceptionType SettingsValidationException
    } #it

    It 'Throws when MailSettings.From is missing' {
        $Settings.MailSettings.Remove(
            'From'
        )

        {
            Test-IISWebFarmSettings `
                -Settings $Settings

        } | Should -Throw `
            -ExceptionType SettingsValidationException
    } #it

    It 'Throws when MailSettings.To is missing' {
        $Settings.MailSettings.Remove(
            'To'
        )

        {
            Test-IISWebFarmSettings `
                -Settings $Settings

        } | Should -Throw `
            -ExceptionType SettingsValidationException
    } #it

    It 'Throws when MailSettings.Server is missing' {
        $Settings.MailSettings.Remove(
            'Server'
        )

        {
            Test-IISWebFarmSettings `
                -Settings $Settings

        } | Should -Throw `
            -ExceptionType SettingsValidationException
    } #it

    It 'SettingsValidationException contains correct exit code' {
        $Exception =
            :new(
                'Test Message'
            )

        $Exception.ExitCode |
            Should -Be (
                :SettingsValidationFailure
            )
    } #it
} #Describe Test-IISWebFarmSettings