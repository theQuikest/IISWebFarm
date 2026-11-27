class HealthProbeResult : ValidationResult {
    [string]$Uri
    [int]$StatusCode
    [long]$ResponseTimeMs

    HealthProbeResult(
        [string]$Target,
        [bool]$Success,
        [string]$Message,
        [string]$Uri,
        [int]$StatusCode,
        [long]$ResponseTimeMs
    ) : base(
        'HealthProbe',
        $Target,
        $Success,
        $Message
    ) {
        $this.Uri            = $Uri
        $this.StatusCode     = $StatusCode
        $this.ResponseTimeMs = $ResponseTimeMs
    }

    [hashtable] ToHashtable() {
        $Result = ([BaseResult]$this).ToHashtable()

        $Result.Uri            = $this.Uri
        $Result.StatusCode     = $this.StatusCode
        $Result.ResponseTimeMs = $this.ResponseTimeMs

        return $Result
    }
} #class HealtProbeResult