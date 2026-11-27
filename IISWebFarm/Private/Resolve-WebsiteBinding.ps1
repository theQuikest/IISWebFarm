function Resolve-WebsiteBinding {
<#
.SYNOPSIS
Retrieves IIS website bindings.

.OUTPUTS
[PSCustomObject]
#>

    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $ComputerName = $env:COMPUTERNAME
    ) #param

    PROCESS {
        Invoke-Command `
            -ComputerName $ComputerName `
            -ScriptBlock {
                Import-Module `
                    WebAdministration `
                    -ErrorAction Stop

                Get-WebBinding | ForEach-Object {
                    $Binding = $_

                    $Parts = $Binding.bindingInformation.Split(':')

                    [PSCustomObject]@{
                        ComputerName      = $env:COMPUTERNAME

                        WebsiteName       = $Binding.ItemXPath `
                            -replace ".*name='([^']+)'.*", '$1'

                        Protocol          = $Binding.Protocol

                        IPAddress         = $Parts[0]

                        Port              = $Parts[1]

                        HostHeader        = $Parts[2]

                        BindingInformation =
                            $Binding.bindingInformation

                        CertificateHash   =
                            $Binding.CertificateHash

                        CertificateStoreName =
                            $Binding.CertificateStoreName

                        SslFlags          =
                            $Binding.sslFlags
                    } #PSCustomObject
                } #foreach
            } `
            -ErrorAction Stop
    } #PROCESS
} #function Resolve-WebsiteBinding