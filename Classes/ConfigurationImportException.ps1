class ConfigurationImportException : IISWebFarmException
{
    ConfigurationImportException(
        [string] $Message
    ) : base(
        $Message,
        [IISWebFarmExitCode]::ConfigurationImportFailure
    )
    {
    } #constructor

    ConfigurationImportException(
        [string] $Message,
        [System.Exception] $InnerException
    ) : base(
        $Message,
        [IISWebFarmExitCode]::ConfigurationImportFailure,
        $InnerException
    )
    {
    } #constructor
} #class ConfigurationImportException