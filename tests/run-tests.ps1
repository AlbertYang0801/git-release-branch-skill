$ErrorActionPreference = 'Stop'

$tests = @(
    'Test-SkillContract.ps1',
    'Test-RunRecordNaming.ps1',
    'Test-ScenarioDefinitions.ps1'
)

foreach ($test in $tests) {
    Write-Host "`n== $test =="
    & (Join-Path $PSScriptRoot $test)
}

Write-Host "`nAll tests passed."
