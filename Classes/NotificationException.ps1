class NotificationException : IISWebFarmException
{
    NotificationException(
        [string] $Message
    ) : base(
        $Message,
        [IISWebFarmExitCode]::NotificationFailure
    )
    {
    } #constructor

    NotificationException(
        [string] $Message,
        [System.Exception] $InnerException
    ) : base(
        $Message,
        [IISWebFarmExitCode]::NotificationFailure,
        $InnerException
    )
    {
    } #constructor
} #class NotificationException