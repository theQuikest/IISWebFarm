class WebsiteValidationException : IISWebFarmException
{
    WebsiteValidationException(
        [string] $Message
    ) : base(
        $Message,
        [IISWebFarmExitCode]::WebsiteValidationFailure
    )
    {
    } #constructor

    WebsiteValidationException(
        [string] $Message,
        [System.Exception] $InnerException
    ) : base(
        $Message,
        [IISWebFarmExitCode]::WebsiteValidationFailure,
        $InnerException
    )
    {
    } #constructor
} #class WebsiteValidationException