$DataFile   = Import-PowerShellDataFile .\$($env:repoName).psd1 -ErrorAction SilentlyContinue
$TestModule = Test-ModuleManifest       .\$($env:repoName).psd1 -ErrorAction SilentlyContinue

Describe "$($env:repoName)-Manifest" {
    Context Validation {
        It "[Import-PowerShellDataFile] - $($env:repoName).psd1 is a valid PowerShell Data File" {
            $DataFile | Should Not BeNullOrEmpty
        }

        It "[Test-ModuleManifest] - $($env:repoName).psd1 should pass the basic test" {
            $TestModule | Should Not BeNullOrEmpty
        }

        It "Should specify at least 2 modules" {
            ($TestModule).RequiredModules.Count | Should BeGreaterThan 1
        }

        'Get-NetView', 'Validate-DCB' | ForEach-Object {
            $module = Find-Module -Name $_ -ErrorAction SilentlyContinue

            It "Should contain the $_ Module" {
                $_ -in ($TestModule).RequiredModules.Name | Should be $true
            }

            It "The $_ module should be available in the PowerShell gallery" {
                $module | Should not BeNullOrEmpty
            }

            Remove-Variable -Name Module -ErrorAction SilentlyContinue
        }
    }
}
