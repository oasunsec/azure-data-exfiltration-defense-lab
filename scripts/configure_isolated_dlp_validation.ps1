param(
  [Parameter(Mandatory)][uri]$LabSiteUrl,
  [Parameter(Mandatory)][ValidatePattern('^[^@\s]+@[^@\s]+\.[^@\s]+$')][string]$AlertRecipient,
  [ValidateSet('CreateSimulation','Enforce','Disable')][string]$Phase = 'CreateSimulation',
  [string]$EvidenceDirectory = 'evidence-private/isolated-dlp-validation'
)
$ErrorActionPreference = 'Stop'
if ($LabSiteUrl.Scheme -ne 'https' -or $LabSiteUrl.AbsolutePath -notlike '/sites/*') {
  throw 'Supply the dedicated HTTPS lab site.'
}
if (-not (Get-Command Get-DlpCompliancePolicy -ErrorAction SilentlyContinue)) {
  throw 'Connect-IPPSSession with DLP management permissions first.'
}
$sitName = 'Lab Financial Record ID'
$sitId = '4AC7F0C2-1A1F-4D18-995A-6ECFBC2133DD'
$packageName = 'Data Defense Lab Synthetic Identifier Rule Pack'
$policyName = 'Data Defense Lab - Isolated Financial ID Validation'
$ruleName = 'Data Defense Lab - Lab Financial Record ID'
$evidencePath = Join-Path (Get-Location) $EvidenceDirectory
New-Item -ItemType Directory -Path $evidencePath -Force | Out-Null

# Preserve the historical rule states and fail if either is absent. This script
# never passes their identities to a Set/New/Remove cmdlet.
$historical = @(
  Get-DlpComplianceRule -Identity 'Data Defense Lab - Strict financial access restriction' -ErrorAction Stop
  Get-DlpComplianceRule -Identity 'Data Defense Lab - Credit card external access block' -ErrorAction Stop
)
$historical | Select-Object Name,Mode,Priority,ParentPolicyName,WhenChanged,AdvancedRule |
  ConvertTo-Json -Depth 12 | Set-Content (Join-Path $evidencePath 'historical-rules-readback.json')

$sit = Get-DlpSensitiveInformationType -Identity $sitName -ErrorAction SilentlyContinue
if (-not $sit) {
  if ($Phase -ne 'CreateSimulation') { throw 'The lab custom sensitive information type does not exist.' }
  $source = Join-Path $PSScriptRoot 'lab_financial_record_rulepack.xml'
  $unicode = Join-Path $evidencePath 'lab-financial-record-rulepack-unicode.xml'
  (Get-Content $source -Raw).Replace('encoding="utf-8"', 'encoding="utf-16"') |
    Set-Content $unicode -Encoding Unicode
  New-DlpSensitiveInformationTypeRulePackage -FileData ([System.IO.File]::ReadAllBytes($unicode)) -Confirm:$false | Out-Null
  $sit = Get-DlpSensitiveInformationType -Identity $sitName -ErrorAction Stop
}
if ([string]$sit.Id -ne $sitId) { throw 'The existing SIT name resolves to an unexpected identifier.' }

$policy = Get-DlpCompliancePolicy -Identity $policyName -ErrorAction SilentlyContinue
if (-not $policy) {
  if ($Phase -ne 'CreateSimulation') { throw 'The isolated diagnostic policy does not exist.' }
  New-DlpCompliancePolicy -Name $policyName -SharePointLocation $LabSiteUrl.AbsoluteUri -Mode TestWithNotifications -ErrorAction Stop | Out-Null
  $policy = Get-DlpCompliancePolicy -Identity $policyName -ErrorAction Stop
}
$locations = @($policy.SharePointLocation | ForEach-Object { $_.Name.TrimEnd('/') })
if ($locations.Count -ne 1 -or $locations[0] -ne $LabSiteUrl.AbsoluteUri.TrimEnd('/')) {
  throw 'The isolated policy is not scoped only to the dedicated lab site.'
}
$rule = Get-DlpComplianceRule -Policy $policyName | Where-Object Name -eq $ruleName
if (-not $rule) {
  if ($Phase -ne 'CreateSimulation') { throw 'The isolated diagnostic rule does not exist.' }
  New-DlpComplianceRule -Name $ruleName -Policy $policyName `
    -ContentContainsSensitiveInformation @(@{Name=$sitName;minCount='1';confidencelevel='High'}) `
    -BlockAccess $true -BlockAccessScope All -NotifyUser LastModifier `
    -GenerateAlert $AlertRecipient -ReportSeverityLevel Low -ErrorAction Stop | Out-Null
  $rule = Get-DlpComplianceRule -Identity $ruleName -ErrorAction Stop
}

$conditions = @($rule.ContentContainsSensitiveInformation)
if ($rule.AdvancedRule) {
  $advanced = $rule.AdvancedRule | ConvertFrom-Json -ErrorAction Stop
  $sub = @($advanced.Condition.SubConditions)
  if ($advanced.Condition.Operator -ne 'And' -or $sub.Count -ne 1 -or $sub[0].ConditionName -ne 'ContentContainsSensitiveInformation') {
    throw 'The saved rule has conditions beyond the single lab identifier classifier.'
  }
  $savedValues = @($sub[0].Value)
  if ($savedValues.Count -eq 1 -and $savedValues[0].Groups) {
    $conditions = @($savedValues[0].Groups[0].Sensitivetypes)
  } else {
    $conditions = $savedValues
  }
}
if ($conditions.Count -ne 1 -or [string]$conditions[0].Name -ne $sitName -or
    [int]$conditions[0].MinCount -ne 1 -or [int]$conditions[0].MinConfidence -ne 85 -or
    -not $rule.BlockAccess -or [string]$rule.BlockAccessScope -ne 'All' -or
    @($rule.NotifyAllowOverride | Where-Object { $null -ne $_ }).Count -ne 0) {
  throw 'The isolated diagnostic rule readback failed validation.'
}

if ($Phase -eq 'Enforce') {
  $simulationPath = Join-Path $evidencePath 'simulation-poll-latest.json'
  if (-not (Test-Path -LiteralPath $simulationPath)) {
    throw 'Simulation evidence is required before enforcement.'
  }
  $simulation = Get-Content -LiteralPath $simulationPath -Raw | ConvertFrom-Json -ErrorAction Stop
  $simulationMatches = @($simulation.ActivityExplorer.AttributableMatches | Where-Object {
    $_.ItemName -like '*Financial_Records_CONFIDENTIAL.docx*' -and
    $_.PolicyName -eq $policyName -and
    $_.RuleName -eq $ruleName -and
    $_.SensitiveInformationTypeId -eq $sitId
  })
  if (-not $simulation.SimulationGatePassed -or $simulationMatches.Count -lt 1 -or
      [string]$policy.Mode -ne 'TestWithNotifications') {
    throw 'The simulation gate is not passed; keep the isolated policy in simulation.'
  }
}

$targetMode = switch ($Phase) {
  'CreateSimulation' { 'TestWithNotifications' }
  'Enforce' { 'Enable' }
  'Disable' { 'Disable' }
}
if ([string]$policy.Mode -ne $targetMode) {
  Set-DlpCompliancePolicy -Identity $policyName -Mode $targetMode -ErrorAction Stop
}
$saved = Get-DlpCompliancePolicy -Identity $policyName -DistributionDetail -ErrorAction Stop
if ($Phase -in @('Enforce','Disable')) {
  $historyPath = Join-Path $evidencePath ("$($Phase.ToLowerInvariant())-distribution-history.jsonl")
  $deadline = (Get-Date).AddMinutes(30)
  do {
    $saved = Get-DlpCompliancePolicy -Identity $policyName -DistributionDetail -ErrorAction Stop
    [pscustomobject]@{
      CheckedAtUtc = [datetime]::UtcNow.ToString('o')
      Mode = [string]$saved.Mode
      DistributionStatus = [string]$saved.DistributionStatus
      DistributionResults = $saved.DistributionResults
    } | ConvertTo-Json -Depth 12 -Compress | Add-Content -LiteralPath $historyPath
    if ([string]$saved.DistributionStatus -eq 'Success') { break }
    if ((Get-Date) -ge $deadline) {
      throw "Distribution did not reach Success for phase $Phase."
    }
    Start-Sleep -Seconds 30
  } while ($true)
}
$savedRule = Get-DlpComplianceRule -Identity $ruleName -ErrorAction Stop
$result = [pscustomobject]@{
  CheckedAtUtc = [datetime]::UtcNow.ToString('o')
  Phase = $Phase
  SensitiveInformationType = [pscustomobject]@{Name=$sit.Name;Id=[string]$sit.Id;Publisher=$sit.Publisher}
  Policy = [pscustomobject]@{Name=$saved.Name;Mode=[string]$saved.Mode;DistributionStatus=[string]$saved.DistributionStatus;DistributionResults=$saved.DistributionResults;SharePointLocations=$locations}
  Rule = [pscustomobject]@{Name=$savedRule.Name;Mode=[string]$savedRule.Mode;Priority=$savedRule.Priority;ConditionCount=1;Classifier=$sitName;BlockAccess=$savedRule.BlockAccess;BlockAccessScope=[string]$savedRule.BlockAccessScope;Overrides=@($savedRule.NotifyAllowOverride | Where-Object {$null -ne $_})}
  HistoricalRules = @($historical | Select-Object Name,Mode,Priority,ParentPolicyName,WhenChanged)
}
$result | ConvertTo-Json -Depth 15 | Set-Content (Join-Path $evidencePath ("$($Phase.ToLowerInvariant())-readback.json"))
$result
