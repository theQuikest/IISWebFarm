class SettingsValidationException : IISWebFarmException
{
    SettingsValidationException(
        [string] $Message
    ) : base(
        $Message,
        [IISWebFarmExitCode]::SettingsValidationFailure
    )
    {
    } #constructor

    SettingsValidationException(
        [string] $Message,
        [System.Exception] $InnerException
    ) : base(
        $Message,
        [IISWebFarmExitCode]::SettingsValidationFailure,
        $InnerException
    )
    {
    } #constructor
} #class SettingsValidationException

