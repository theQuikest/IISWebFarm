class ValidationResult : BaseResult {
    [string]$Check
    [string]$Target
    [bool]$Success
    [string]$Message

    ValidationResult(
        [string]$Check,
        [string]$Target,
        [bool]$Success,
        [string]$Message
    ) : base() {
        $this.Check   = $Check
        $this.Target  = $Target
        $this.Success = $Success
        $this.Message = $Message
    }

    [hashtable] ToHashtable() {
        $Hash = $this.GetBaseHashtable()

        $Hash.Check   = $this.Check
        $Hash.Target  = $this.Target
        $Hash.Success = $this.Success
        $Hash.Message = $this.Message

        return $Hash
    }

    [string] ToJson() {
        return (
            $this.ToHashtable() |
            ConvertTo-Json -Depth 5 -Compress
        )
    }

    [string] ToString() {
        return "[{0}] {1} - {2}" -f `
            $(if ($this.Success) { 'PASS' } else { 'FAIL' }),
            $this.Check,
            $this.Target
    }
} #class ValidationResult