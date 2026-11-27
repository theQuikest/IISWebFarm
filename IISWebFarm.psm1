# Classes eerst laden
. $PSScriptRoot\Classes\BaseResult.ps1
. $PSScriptRoot\Classes\ValidationResult.ps1
. $PSScriptRoot\Classes\HealthProbeResult.ps1
. $PSScriptRoot\Classes\ServerValidationResult.ps1
. $PSScriptRoot\Classes\ValidationReport.ps1

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

Write-Host "Public Files Found: $($PublicFiles.Count)"

$PublicFiles | ForEach-Object {
    Write-Host $_.FullName
}

Write-Host "PSScriptRoot = [$PSScriptRoot]"
Write-Host "Public Path  = [$PSScriptRoot\Public]"
Write-Host "Loading Public Functions:"

Get-Command -CommandType Function |
    Where-Object {
        $_.Source -eq ''
    } |
    Select-Object Name


Export-ModuleMember -Function *
