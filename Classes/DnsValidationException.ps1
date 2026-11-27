class DnsValidationException : IISWebFarmException
{
    DnsValidationException(
        [string] $Message
    ) : base(
        $Message,
        [IISWebFarmExitCode]::DnsFailure
    )
    {
    } #constructor

    DnsValidationException(
        [string] $Message,
        [System.Exception] $InnerException
    ) : base(
        $Message,
        [IISWebFarmExitCode]::DnsFailure,
        $InnerException
    )
    {
    } #constructor
} #class DnsValidationException