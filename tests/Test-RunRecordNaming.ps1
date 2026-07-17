$ErrorActionPreference = 'Stop'

function ConvertTo-SafeRequirementName {
    param([Parameter(Mandatory)][string]$Name)

    $fullWidthColon = [string][char]0xFF1A
    $pattern = '[\\/:*?"<>|\s' + $fullWidthColon + ']'
    return [regex]::Replace($Name, $pattern, '')
}

function Get-RunRecordFileName {
    param(
        [Parameter(Mandatory)][datetime]$Date,
        [Parameter(Mandatory)][string]$RequirementName,
        [Parameter(Mandatory)][string]$Scene,
        [Parameter(Mandatory)][string]$Status,
        [string[]]$ExistingNames = @()
    )

    if (@('release', 'tag') -notcontains $Scene) { throw 'Invalid scene' }

    $safeName = ConvertTo-SafeRequirementName -Name $RequirementName
    if ([string]::IsNullOrEmpty($safeName)) { throw 'Empty sanitized requirement name' }

    $stem = '{0}-{1}-{2}-{3}' -f $Date.ToString('yyyy-MM-dd'), $safeName, $Scene, $Status
    $candidate = "$stem.md"
    $suffix = 2
    while ($ExistingNames -contains $candidate) {
        $candidate = "$stem-$suffix.md"
        $suffix++
    }
    return $candidate
}

$cases = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $PSScriptRoot 'naming-cases.json') | ConvertFrom-Json
$date = [datetime]'2026-07-17'

foreach ($case in $cases) {
    if ($case.expect_error) {
        $failedAsExpected = $false
        try {
            Get-RunRecordFileName $date $case.requirement $case.scene $case.status $case.existing | Out-Null
        } catch {
            $failedAsExpected = $true
        }
        if (-not $failedAsExpected) { throw "FAIL [$($case.name)]: expected an error" }
    } else {
        $actual = Get-RunRecordFileName $date $case.requirement $case.scene $case.status $case.existing
        if ($actual -ne $case.expected) {
            throw "FAIL [$($case.name)]: expected '$($case.expected)', actual '$actual'"
        }
    }
    Write-Host "PASS [$($case.name)]"
}

Write-Host 'Run record naming checks passed.'
