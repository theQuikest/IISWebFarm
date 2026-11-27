class UnexpectedIISWebFarmException : IISWebFarmException
{
    UnexpectedIISWebFarmException(
        [string] $Message
    ) : base(
        $Message,
        [IISWebFarmExitCode]::UnexpectedError
    )
    {
    } #constructor

    UnexpectedIISWebFarmException(
        [string] $Message,
        [System.Exception] $InnerException
    ) : base(
        $Message,
        [IISWebFarmExitCode]::UnexpectedError,
        $InnerException
    )
    {
    } #constructor
} #class UnexpectedIISWebFarmException