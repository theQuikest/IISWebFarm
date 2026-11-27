class ApplicationPoolValidationException : IISWebFarmException
{
    ApplicationPoolValidationException(
        [string] $Message
    ) : base(
        $Message,
        [IISWebFarmExitCode]::ApplicationPoolValidationFailure
    )
    {
    } #constructor

    ApplicationPoolValidationException(
        [string] $Message,
        [System.Exception] $InnerException
    ) : base(
        $Message,
        [IISWebFarmExitCode]::ApplicationPoolValidationFailure,
        $InnerException
    )
    {
    } #constructor

} #class ApplicationPoolValidationException