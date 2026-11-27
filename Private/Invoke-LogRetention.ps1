function Invoke-LogRetention {
<#
.SYNOPSIS
Applies log retention to the logging directory.
.DESCRIPTION
Removes log files older than the configured retention period.
.PARAMETER LogRoot
Directory containing log files.
.PARAMETER RetentionDays
Number of days to retain log files.
.OUTPUTS
PSCustomObject
.NOTES
Author      : theQuikest
Version     : 1.1.0.0
Last Updated: 2026-11-26
#>

    [CmdletBinding(
        SupportsShouldProcess
    )]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $LogRoot,

        [Parameter(Mandatory)]
        [ValidateRange(1,3650)]
        [int]
        $RetentionDays
    ) #param

    try {
        Write-Verbose "Applying log retention."

        if (-not (Test-Path -Path $LogRoot)) {
            Write-Verbose ("Log directory does not exist.")

            return [PSCustomObject]@{
                LogRoot          = $LogRoot

                RetentionDays    = $RetentionDays

                FilesExamined    = 0

                FilesRemoved     = 0

                RetentionCutoff  = $null
            }
        } #if

        $RetentionCutoff = (
            Get-Date
        ).AddDays(-$RetentionDays)

        Write-Verbose ("Retention cutoff = $RetentionCutoff")

        $Files = Get-ChildItem `
            -Path $LogRoot `
            -File `
            -Recurse `
            -Include '*.log','*.jsonl' `
            -ErrorAction Stop

        $ExpiredFiles = $Files |
            Where-Object {
                $_.LastWriteTime -lt $RetentionCutoff
            }

        $FilesRemoved = 0

        foreach ($File in $ExpiredFiles) {
            if ($PSCmdlet.ShouldProcess(
                $File.FullName,
                'Remove expired log file'))
            {
                Write-Verbose ("Removing '$($File.FullName)'")

                Remove-Item `
                    -Path $File.FullName `
                    -Force `
                    -ErrorAction Stop

                $FilesRemoved++
            } #if
        } #foreach

        return [PSCustomObject]@{
            LogRoot         = $LogRoot

            RetentionDays   = $RetentionDays

            FilesExamined   = $Files.Count

            FilesRemoved    = $FilesRemoved

            RetentionCutoff = $RetentionCutoff
        }
    } #try

    catch {
        throw [LogRetentionException]::new(
            (
                "Failed to apply log retention. " +
                "LogRoot='$LogRoot'."
            ),
            $_.Exception
        )        
    } #catch
} #function Invoke-LogRetention