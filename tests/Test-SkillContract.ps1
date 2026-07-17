$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$skill = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $projectRoot 'SKILL.md')
$readme = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $projectRoot 'README.md')
$contracts = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $PSScriptRoot 'contract-patterns.json') | ConvertFrom-Json

foreach ($contract in $contracts) {
    if ($skill -notmatch $contract.pattern) {
        throw "FAIL [$($contract.name)]: pattern not found"
    }
    Write-Host "PASS [$($contract.name)]"
}

$skillVersion = [regex]::Match($skill, '(?m)^version: (\d+\.\d+\.\d+)$').Groups[1].Value
$readmeVersion = [regex]::Match($readme, '(?m)^.*`(\d+\.\d+\.\d+)`$').Groups[1].Value
if ($skillVersion -ne $readmeVersion) {
    throw "FAIL [version match]: SKILL=$skillVersion README=$readmeVersion"
}
Write-Host 'PASS [README version matches SKILL]'
Write-Host 'Skill contract checks passed.'
