class ServerValidationResult {
    [string]$ServerName

    [System.Collections.Generic.List[BaseResult]]$Results

    ServerValidationResult(
        [string]$ServerName
    ) {
        $this.ServerName = $ServerName

        $this.Results = `
            [System.Collections.Generic.List[BaseResult]]::new()
    }

    [void] AddResult(
        [BaseResult]$Result
    ) {
        $this.Results.Add($Result)
    }

    [int] GetSuccessCount() {
        return @(
            $this.Results |
            Where-Object Success
        ).Count
    }

    [int] GetFailedCount() {

        return @(
            $this.Results |
            Where-Object { -not $_.Success }
        ).Count
    }

    [bool] IsHealthy() {
        return ($this.GetFailedCount() -eq 0)
    }

    [BaseResult[]] GetFailedResults() {
        return @(
            $this.Results |
            Where-Object { -not $_.Success }
        )
    }

    [hashtable] ToHashtable() {
        return @{
            ServerName  = $this.ServerName
            IsHealthy   = $this.IsHealthy()
            Successes   = $this.GetSuccessCount()
            Failures    = $this.GetFailedCount()
            Results     = @(
                foreach ($Result in $this.Results) {
                    $Result.ToHashtable()
                }
            )
        }
    }

    [string] ToJson() {
        return (
            $this.ToHashtable() |
            ConvertTo-Json -Depth 10 -Compress
        )
    }
} #class ServerValidationResult