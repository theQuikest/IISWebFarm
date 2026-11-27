function Initialize-ExecutionMetadata {
<#
.SYNOPSIS
Writes execution metadata to the verbose stream.
.DESCRIPTION
Captures runtime information useful for troubleshooting,
auditing and log analysis.
.PARAMETER ScriptVersion
Version of the calling script.
.OUTPUTS
[IISWebFarmExecutionContext]
Execution metadata including RunId,
user identity, timestamps and version.
.NOTES
Author      : theQuikest
Version     : 1.1.0.0
Last Updated: 2026-11-26
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [version]
    $ScriptVersion
) #param

$Identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()

$IsAdmin = [System.Security.Principal.WindowsPrincipal]::new(
    $Identity).IsInRole(
        [System.Security.Principal.WindowsBuiltInRole]::Administrator)

$OperatingSystem = (
    Get-CimInstance `
        -ClassName Win32_OperatingSystem `
        -Verbose:$false
).Caption

Write-Verbose ("Execution Metadata:")
Write-Verbose ("User           : $($env:USERDOMAIN)\$($env:USERNAME)")
Write-Verbose ("Is Admin       : $IsAdmin")
Write-Verbose ("Computer Name  : $env:COMPUTERNAME")
Write-Verbose ("Operating System: $OperatingSystem")
Write-Verbose ("Host           : $($Host.Name)")
Write-Verbose ("PS Edition     : $($PSVersionTable.PSEdition)")
Write-Verbose ("PS Version     : $($PSVersionTable.PSVersion)")
Write-Verbose ("Runtime        : $(Get-Date)")
Write-Verbose ("Script         : $($MyInvocation.ScriptName)")
Write-Verbose ("Script Version : $ScriptVersion")
Write-Verbose ("")
} #function Initialize-ExecutionMetadata