function Write-JsonLine {
<#
.SYNOPSIS
Writes a JSON Lines entry.
.DESCRIPTION
Serializes an object and appends it as a single JSON
record to a JSONL file.
.PARAMETER Path
Path to the JSONL file.
.PARAMETER InputObject
Object to serialize.
.INPUTS
[psobject]

Objects to be written as JSONL records.
.OUTPUTS
None

Writes data to log file.
No pipeline output.
.NOTES
Author      : JP Kuipers
Version     : 1.1.0.0
Last Updated: 2026-11-26
#>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path,

        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [object]
        $InputObject
    ) #param

    try {
        Write-Verbose ("Writing JSONL record.")

        if (-not (Test-Path -Path $Path))
        {
            throw [System.IO.FileNotFoundException]::new(
                "JSONL file not found.",
                $Path
            )
        } #if

        $Record = [PSCustomObject]@{

            Timestamp = (
                Get-Date
            ).ToUniversalTime().ToString('o')

            Data = $InputObject
        }

        $Json = $Record |
            ConvertTo-Json `
                -Depth 10 `
                -Compress

        Add-Content `
            -Path $Path `
            -Value $Json `
            -Encoding UTF8 `
            -ErrorAction Stop

        Write-Verbose (
            "JSONL record written to '$Path'."
        )
    } #try

    catch {
        throw [JsonLoggingException]::new(
            (
                "Failed to write JSONL record. " +
                "Path='$Path'."
            ),
            $_.Exception
        )
    } #catch
} #function Write-JsonLine