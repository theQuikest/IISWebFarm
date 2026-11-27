BeforeAll {
    . $PSScriptRoot\..\..\Classes\IISWebFarmExitCode.ps1

    . $PSScriptRoot\..\..\Classes\IISWebFarmException.ps1

    . $PSScriptRoot\..\..\Classes\LoggingInitializationException.ps1
    . $PSScriptRoot\..\..\Classes\SettingsValidationException.ps1
    . $PSScriptRoot\..\..\Classes\DnsValidationException.ps1
    . $PSScriptRoot\..\..\Classes\HttpsValidationException.ps1
    . $PSScriptRoot\..\..\Classes\HealthProbeException.ps1
    . $PSScriptRoot\..\..\Classes\WebsiteValidationException.ps1
    . $PSScriptRoot\..\..\Classes\ApplicationPoolValidationException.ps1
    . $PSScriptRoot\..\..\Classes\WebDeployValidationException.ps1
    . $PSScriptRoot\..\..\Classes\NotificationException.ps1
    . $PSScriptRoot\..\..\Classes\UnexpectedIISWebFarmException.ps1
} #BeforeAll

Describe 'IISWebFarmExitCode' {
    It 'Contains unique values' {
        $Codes =
            [System.Enum]::GetValues(
                [IISWebFarmExitCode]
            )

        $Codes.Count |
            Should -Be (
                ($Codes | Select-Object -Unique).Count
            )
    } #it
} #Describe IISWebFarmExitCode

$TestCases = @(
    @{
        Name     = 'LoggingInitializationException'
        Type     = [LoggingInitializationException]
        ExitCode = [IISWebFarmExitCode]::LoggingInitializationFailure
    }
    @{
        Name     = 'LogRetentionException'
        Type     = [LogRetentionException]
        ExitCode = [IISWebFarmExitCode]::LogRetentionFailure
    }
    @{
        Name     = 'SettingsValidationException'
        Type     = [SettingsValidationException]
        ExitCode = [IISWebFarmExitCode]::SettingsValidationFailure
    }
    @{
        Name     = 'DnsValidationException'
        Type     = [DnsValidationException]
        ExitCode = [IISWebFarmExitCode]::DnsFailure
    }
    @{
        Name     = 'HttpsValidationException'
        Type     = [HttpsValidationException]
        ExitCode = [IISWebFarmExitCode]::HttpsFailure
    }
    @{
        Name     = 'HealthProbeException'
        Type     = [HealthProbeException]
        ExitCode = [IISWebFarmExitCode]::HealthProbeFailure
    }
    @{
        Name     = 'WebsiteValidationException'
        Type     = [WebsiteValidationException]
        ExitCode = [IISWebFarmExitCode]::WebsiteValidationFailure
    }
    @{
        Name     = 'ApplicationPoolValidationException'
        Type     = [ApplicationPoolValidationException]
        ExitCode = [IISWebFarmExitCode]::ApplicationPoolValidationFailure
    }
    @{
        Name     = 'WebDeployValidationException'
        Type     = [WebDeployValidationException]
        ExitCode = [IISWebFarmExitCode]::WebDeployFailure
    }
    @{
        Name     = 'NotificationException'
        Type     = [NotificationException]
        ExitCode = [IISWebFarmExitCode]::NotificationFailure
    }
    @{
        Name     = 'UnexpectedIISWebFarmException'
        Type     = [UnexpectedIISWebFarmException]
        ExitCode = [IISWebFarmExitCode]::UnexpectedError
    }
) #$TestCases

Describe 'IISWebFarm Exceptions' {
    It '<Name> inherits from IISWebFarmException' -ForEach $TestCases {
        $Exception = $Type::new(
            'Test Message'
        )

        $Exception |
            Should -BeOfType $Type

        $Exception |
            Should -BeOfType [IISWebFarmException]
    } #it

    It '<Name> contains correct exit code' -ForEach $TestCases {
        $Exception = $Type::new(
            'Test Message'
        )

        $Exception.ExitCode |
            Should -Be $ExitCode
    } #it

    It '<Name> supports inner exceptions' -ForEach $TestCases {
        $InnerException =
            [System.Exception]::new(
                'Inner Exception'
            )

        $Exception = $Type::new(
            'Outer Exception',
            $InnerException
        )

        $Exception.InnerException |
            Should -Not -BeNullOrEmpty

        $Exception.InnerException.Message |
            Should -Be 'Inner Exception'
    } #it

    It '<Name> preserves exception message' -ForEach $TestCases {
        $Exception = $Type::new(
            'Test Message'
        )

        $Exception.Message |
            Should -Be 'Test Message'
    } #it
} #Describe IISWebFarm Exceptions
