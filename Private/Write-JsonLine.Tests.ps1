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

        $TestData = [ordered]@{
            ServerName = 'TestServer'

            CheckName = 'TestCheck'

            ResultName = 'TestResult'

            PropertyName = 'TestProperty'

            PropertyValue = 'TestValue'

            Message = 'Test Message'
        }
    } #BeforeEach

    It 'Writes a JSONL record' {
        $Object = [PSCustomObject]@{
            Check = $TestData.CheckName

            Result = $TestData.ResultName
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

            Server = $TestData.ServerName
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

            Server = $TestData.ServerName
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
            $($TestData.PropertyName) =
                $TestData.PropertyValue
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

        $Record.Data.$($TestData.PropertyName) |
            Should -Be $TestData.PropertyValue
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
                    Test = $TestData.PropertyValue
                }
        } | Should -Throw `
            -ExceptionType JsonLoggingException
    } #it

    It 'JsonLoggingException contains correct exit code' {
        $Exception = :new(
            $TestData.Message
        )

        $Exception.ExitCode |
            Should -Be (
                :JsonLoggingFailure
            )
    } #it
} #Describe Write-JsonLine