class HttpsValidationException : IISWebFarmException
{
    HttpsValidationException(
        [string] $Message
    ) : base(
        $Message,
        [IISWebFarmExitCode]::HttpsFailure
    )
    {
    } #constructor
    
    HttpsValidationException(
        [string] $Message,
        [System.Exception] $InnerException
    ) : base(
        $Message,
        [IISWebFarmExitCode]::HttpsFailure,
        $InnerException
    )
    {
    } #constructor
} #class HttpsValidationException