BeforeAll {
    . $PSScriptRoot\..\..\Classes\IISWebFarmExitCode.ps1

    . $PSScriptRoot\..\..\Classes\IISWebFarmException.ps1

    . $PSScriptRoot\..\..\Classes\JsonLoggingException.ps1

    . $PSScriptRoot\..\..\Private\Write-JsonLine.ps1
} #BeforeAll

Describe 'Write-JsonLine' {
    BeforeEach {
        $JsonFile = Join-Path `
            -Path $TestDrive `
            -ChildPath 'test.jsonl'

        New-Item `
            -Path $JsonFile `
            -ItemType File `
            -Force | Out-Null
    } #BeforeEach

    It 'Writes a JSONL record' {
        $Object = [PSCustomObject]@{
            Check  = 'HealthProbe'

            Result = 'Success'
        }

        Write-JsonLine `
            -Path $JsonFile `
            -InputObject $Object

        $Content = Get-Content `
            -Path $JsonFile

        $Content.Count |
            Should -Be 1
    } #it

    It 'Creates valid JSON' {
        $Object = [PSCustomObject]@{
            Server = 'FAMWEB1'
        }

        Write-JsonLine `
            -Path $JsonFile `
            -InputObject $Object

        {
            $null = (
                Get-Content `
                    -Path $JsonFile `
                    -Raw |
                ConvertFrom-Json
            )
        } | Should -Not -Throw
    } #it

    It 'Contains Timestamp property' {
        $Object = [PSCustomObject]@{
            Server = 'FAMWEB1'
        }

        Write-JsonLine `
            -Path $JsonFile `
            -InputObject $Object

        $Record = (
            Get-Content `
                -Path $JsonFile `
                -Raw |
            ConvertFrom-Json
        )

        $Record.Timestamp |
            Should -Not -BeNullOrEmpty
    } #it

    It 'Contains Data property' {
        $Object = [PSCustomObject]@{
            Server = 'FAMWEB1'
        }

        Write-JsonLine `
            -Path $JsonFile `
            -InputObject $Object

        $Record = (
            Get-Content `
                -Path $JsonFile `
                -Raw |
            ConvertFrom-Json
        )

        $Record.Data.Server |
            Should -Be 'FAMWEB1'
    } #it

    It 'Appends multiple records' {
        1..3 | ForEach-Object {

            Write-JsonLine `
                -Path $JsonFile `
                -InputObject @{
                    Number = $_
                }

        } #foreach

        (
            Get-Content `
                -Path $JsonFile
        ).Count |
            Should -Be 3
    } #it

    It 'Throws JsonLoggingException when file is missing' {
        Remove-Item `
            -Path $JsonFile `
            -Force

        {
            Write-JsonLine `
                -Path $JsonFile `
                -InputObject @{
                    Test = 'Value'
                }

        } | Should -Throw `
            -ExceptionType JsonLoggingException
    } #it

    It 'JsonLoggingException contains correct exit code' {
        $Exception =
            :new(
                'Test Message'
            )

        $Exception.ExitCode |
            Should -Be (
                :JsonLoggingFailure
            )
    } #it
} #Describe Write-JsonLine