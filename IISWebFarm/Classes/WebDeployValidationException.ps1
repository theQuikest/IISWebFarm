class WebDeployValidationException : IISWebFarmException
{
    WebDeployValidationException(
        [string] $Message
    ) : base(
        $Message,
        [IISWebFarmExitCode]::WebDeployFailure
    )
    {
    } #constructor

    WebDeployValidationException(
        [string] $Message,
        [System.Exception] $InnerException
    ) : base(
        $Message,
        [IISWebFarmExitCode]::WebDeployFailure,
        $InnerException
    )
    {
    } #constructor
} #class WebDeployValidationException