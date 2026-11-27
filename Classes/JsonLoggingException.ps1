class JsonLoggingException : IISWebFarmException
{
    JsonLoggingException(
        [string] $Message
    ) : base(
        $Message,
        [IISWebFarmExitCode]::JsonLoggingFailure
    )
    {
    } #constructor

    JsonLoggingException(
        [string] $Message,
        [System.Exception] $InnerException
    ) : base(
        $Message,
        [IISWebFarmExitCode]::JsonLoggingFailure,
        $InnerException
    )
    {
    } #constructor
} #class JsonLoggingException