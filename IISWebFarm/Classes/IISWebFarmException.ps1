class IISWebFarmException : System.Exception
{
    [IISWebFarmExitCode] $ExitCode

    IISWebFarmException(
        [string] $Message,
        [IISWebFarmExitCode] $ExitCode
    ) : base($Message)
    {
        $this.ExitCode = $ExitCode

    } #constructor

    IISWebFarmException(
        [string] $Message,
        [IISWebFarmExitCode] $ExitCode,
        [System.Exception] $InnerException
    ) : base(
        $Message,
        $InnerException
    )
    {
        $this.ExitCode = $ExitCode

    } #constructor

} #class IISWebFarmException