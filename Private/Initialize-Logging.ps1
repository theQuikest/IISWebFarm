function Initialize-Logging {
<#
.SYNOPSIS
Initializes logging for the current script execution.
.DESCRIPTION
Creates the log directory if required, starts a transcript
and prepares optional JSONL logging.
.PARAMETER LogRoot
Directory where log files are stored.
.PARAMETER ScriptName
Name of the calling script.
.PARAMETER JsonLines
Enables JSONL logging.
.OUTPUTS
[IISWebFarmLogContext]
Logging configuration and file locations
used during execution.
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
    $LogRoot,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]
    $ScriptName,

    [Parameter()]
    [switch]
    $JsonLines
) #param

try {
    Write-Verbose ("Initializing logging.")

    #
    # Create log directory.
    #
    if (-not (Test-Path -Path $LogRoot))
    {
        Write-Verbose ("Creating log directory.")

        New-Item `
            -Path $LogRoot `
            -ItemType Directory `
            -Force `
            -ErrorAction Stop | Out-Null
    } #if

    $Timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'

    $TranscriptPath = Join-Path `
        -Path $LogRoot `
        -ChildPath "$ScriptName-$Timestamp.log"

    $JsonLinesPath = $null

    if ($JsonLines)
    {
        $JsonLinesPath = Join-Path `
            -Path $LogRoot `
            -ChildPath "$ScriptName-$Timestamp.jsonl"

        Write-Verbose ("JSONL logging enabled.")
        Write-Verbose ("JSONL path = $JsonLinesPath")
    } #if

    Start-Transcript `
        -Path $TranscriptPath `
        -Force `
        -ErrorAction Stop | Out-Null

    Write-Verbose ("Transcript started.")
    Write-Verbose ("Transcript path = $TranscriptPath")
    
    return [PSCustomObject]@{
        LogRoot        = $LogRoot

        TranscriptPath = $TranscriptPath

        JsonLinesPath  = $JsonLinesPath

        JsonLines      = $JsonLines.IsPresent

        Timestamp      = $Timestamp
    } #return
} #try
catch {
    throw [LoggingInitializationException]::new(
        (
            "Failed to initialize logging. " +
            "LogRoot='$LogRoot'."
        ),
        $_.Exception
    )
} #catch
} #function Initialize-Logging