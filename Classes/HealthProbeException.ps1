class HealthProbeException : IISWebFarmException
{
    HealthProbeException(
        [string] $Message
    ) : base(
        $Message,
        [IISWebFarmExitCode]::HealthProbeFailure
    )
    {
    } #constructor

    HealthProbeException(
        [string] $Message,
        [System.Exception] $InnerException
    ) : base(
        $Message,
        [IISWebFarmExitCode]::HealthProbeFailure,
        $InnerException
    )
    {
    } #constructor
} #class HealthProbeException