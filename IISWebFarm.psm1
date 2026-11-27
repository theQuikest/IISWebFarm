# Core
. $PSScriptRoot\Classes\BaseResult.ps1

# Results
. $PSScriptRoot\Classes\ValidationResult.ps1
. $PSScriptRoot\Classes\HealthProbeResult.ps1
. $PSScriptRoot\Classes\IISWebFarmRequirementResult.ps1

# Aggregation
. $PSScriptRoot\Classes\ServerValidationResult.ps1
. $PSScriptRoot\Classes\ValidationReport.ps1

# Exit Codes
. $PSScriptRoot\Classes\IISWebFarmExitCodes.ps1

# Base Exception
. $PSScriptRoot\Classes\IISWebFarmException.ps1

# Derived Exceptions
. $PSScriptRoot\Classes\LoggingInitializationException.ps1
. $PSScriptRoot\Classes\JsonLoggingException.ps1
. $PSScriptRoot\Classes\ConfigurationImportException.ps1
. $PSScriptRoot\Classes\SettingsValidationException.ps1
. $PSScriptRoot\Classes\DnsValidationException.ps1
. $PSScriptRoot\Classes\HttpsValidationException.ps1
. $PSScriptRoot\Classes\HealthProbeException.ps1
. $PSScriptRoot\Classes\WebsiteValidationException.ps1
. $PSScriptRoot\Classes\ApplicationPoolValidationException.ps1
. $PSScriptRoot\Classes\WebDeployValidationException.ps1
. $PSScriptRoot\Classes\NotificationException.ps1
. $PSScriptRoot\Classes\UnexpectedIISWebFarmException.ps1

# Private
Get-ChildItem `
    -Path "$PSScriptRoot\Private" `
    -Filter '*.ps1' |
Where-Object {
    $_.BaseName -notlike '*.Tests'
} |
ForEach-Object {
    . $_.FullName
} #foreach

# Public
Get-ChildItem `
    -Path "$PSScriptRoot\Public" `
    -Filter '*.ps1' |
Where-Object {
    $_.BaseName -notlike '*.Tests'
} |
ForEach-Object {
    . $_.FullName
} #foreach

$PublicFiles = Get-ChildItem `
    -Path "$PSScriptRoot\Public" `
    -Filter '*.ps1'
    Where-Object {
    $_.BaseName -notlike '*.Tests'
} |
ForEach-Object {
    . $_.FullName
} #foreach

Export-ModuleMember -Function *
