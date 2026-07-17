$ErrorActionPreference = 'Stop'

$scenarioPath = Join-Path $PSScriptRoot 'scenarios.json'
$scenarios = Get-Content -Raw -Encoding UTF8 -LiteralPath $scenarioPath | ConvertFrom-Json

if ($scenarios.Count -lt 6) {
    throw "FAIL [scenario count]: expected at least 6, actual $($scenarios.Count)"
}

$names = @{}
foreach ($scenario in $scenarios) {
    if ([string]::IsNullOrWhiteSpace($scenario.name)) { throw 'FAIL: scenario name is required' }
    if ($names.ContainsKey($scenario.name)) { throw "FAIL: duplicate scenario name '$($scenario.name)'" }
    if ([string]::IsNullOrWhiteSpace($scenario.prompt)) { throw "FAIL [$($scenario.name)]: prompt is required" }
    if ($scenario.expected.Count -eq 0) { throw "FAIL [$($scenario.name)]: expected behaviors are required" }
    $names[$scenario.name] = $true
    Write-Host "PASS [$($scenario.name)]"
}

Write-Host 'Scenario definition checks passed.'
