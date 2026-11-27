class ValidationReport {
    [string]$RunId

    [datetime]$Started

    [datetime]$Finished

    [string]$Version

    [System.Collections.Generic.List[ServerValidationResult]]$Servers

    ValidationReport(
        [string]$Version
    ) {
        $this.RunId    = [guid]::NewGuid().Guid
        $this.Version  = $Version
        $this.Started  = Get-Date

        $this.Servers  = `
            [System.Collections.Generic.List[ServerValidationResult]]::new()
    }

    [void] AddServer(
        [ServerValidationResult]$Server
    ) {

        $this.Servers.Add($Server)
    }

    [void] Complete() {
        $this.Finished = Get-Date
    }

    [timespan] GetDuration() {
        if (-not $this.Finished) {
            return (Get-Date) - $this.Started
        }
        return $this.Finished - $this.Started
    }

    [BaseResult[]] GetFailedResults() {
        $FailedResults = @()

        foreach ($Server in $this.Servers) {
            $FailedResults += $Server.GetFailedResults()
        } #foreach

        return $FailedResults
    }

    [hashtable] GetSummary() {
        $TotalChecks = 0
        $TotalFailed = 0

        foreach ($Server in $this.Servers) {
            $TotalChecks += $Server.Results.Count
            $TotalFailed += $Server.GetFailedCount()
        } #foreach

        return @{
            RunId            = $this.RunId
            Version          = $this.Version
            Started          = $this.Started.ToString('o')
            Finished         = $(if ($this.Finished) {
                $this.Finished.ToString('o')
            })
            DurationSeconds  = [math]::Round(
                $this.GetDuration().TotalSeconds,
                2
            )
            Servers          = $this.Servers.Count
            Checks           = $TotalChecks
            FailedChecks     = $TotalFailed
            SuccessfulChecks = $TotalChecks - $TotalFailed
            Success          = ($TotalFailed -eq 0)
        }
    }

    [hashtable] ToHashtable() {
        return @{
            Summary = $this.GetSummary()
            Servers = @(
                foreach ($Server in $this.Servers) {
                    $Server.ToHashtable()
                }
            )
        }
    }

    [string] ToJson() {
        return (
            $this.ToHashtable() |
            ConvertTo-Json -Depth 20 -Compress
        )
    }
} #class Validation Report