class LogRetentionException : IISWebFarmException
{
    LogRetentionException(
        [string] $Message
    ) : base(
        $Message,
        [IISWebFarmExitCode]::LogRetentionFailure
    )
    {
    } #constructor

    LogRetentionException(
        [string] $Message,
        [System.Exception] $InnerException
    ) : base(
        $Message,
        [IISWebFarmExitCode]::LogRetentionFailure,
        $InnerException
    )
    {
    } #constructor

} #class LogRetentionException