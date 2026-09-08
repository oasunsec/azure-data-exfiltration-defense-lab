param(
  [Parameter(Mandatory)][uri]$LabSiteUrl,
  [Parameter(Mandatory)]
  [ValidatePattern('^[^@\s]+@[^@\s]+\.[^@\s]+$')][string]$AlertRecipient,
  [ValidateSet('TestWithoutNotifications','Enable')][string]$Mode = 'TestWithoutNotifications'
)
$ErrorActionPreference = 'Stop'
if ($LabSiteUrl.Scheme -ne 'https' -or $LabSiteUrl.AbsolutePath -notlike '/sites/*') {
  throw 'Supply the dedicated HTTPS lab site, not a tenant-wide location.'
}
if (-not (Get-Command Get-DlpCompliancePolicy -ErrorAction SilentlyContinue)) {
  throw 'Connect-IPPSSession with DLP management permissions is required.'
}
$policyName = 'Data Defense Lab - Financial external access'
$ruleName = 'Data Defense Lab - Strict financial access restriction'
$policy = Get-DlpCompliancePolicy | Where-Object Name -eq $policyName
if ($policy) {
  $locations = @($policy.SharePointLocation | ForEach-Object { $_.Name.TrimEnd('/') })
  if ($locations.Count -ne 1 -or $locations[0] -ne $LabSiteUrl.AbsoluteUri.TrimEnd('/')) {
    throw 'Existing policy scope does not match the single requested lab site.'
  }
}
if (-not $policy) {
  New-DlpCompliancePolicy -Name $policyName -SharePointLocation $LabSiteUrl.AbsoluteUri -Mode TestWithoutNotifications -ErrorAction Stop | Out-Null
}
$rule = Get-DlpComplianceRule -Policy $policyName | Where-Object Name -eq $ruleName
if (-not $rule) {
  New-DlpComplianceRule -Name $ruleName -Policy $policyName `
    -ContentContainsSensitiveInformation @(@{Name='Credit Card Number';minCount='1';confidencelevel='High'}) `
    -AccessScope NotInOrganization -BlockAccess $true -BlockAccessScope All `
    -NotifyUser LastModifier -GenerateAlert $AlertRecipient -ErrorAction Stop | Out-Null
}
$confirmed = Get-DlpComplianceRule -Identity $ruleName -ErrorAction Stop
# NotifyAllowOverride is an enum array: $false enables FalsePositive overrides.
$overrides = @($confirmed.NotifyAllowOverride | Where-Object { $null -ne $_ })
$classifiers = @($confirmed.ContentContainsSensitiveInformation)
$accessScope = [string]$confirmed.AccessScope
# Portal saves can move both predicates into AdvancedRule. Accept only the
# equivalent two-condition AND expression; reject unfamiliar structures.
if ($confirmed.AdvancedRule) {
  $advanced = $confirmed.AdvancedRule | ConvertFrom-Json -ErrorAction Stop
  $conditions = @($advanced.Condition.SubConditions)
  $access = @($conditions | Where-Object ConditionName -eq 'AccessScope')
  $content = @($conditions | Where-Object ConditionName -eq 'ContentContainsSensitiveInformation')
  if ($advanced.Version -ne '1.0' -or $advanced.Condition.Operator -ne 'And' -or
      $conditions.Count -ne 2 -or $access.Count -ne 1 -or $content.Count -ne 1 -or
      @($content[0].Value).Count -ne 1 -or $content[0].Value[0].Operator -ne 'And' -or
      @($content[0].Value[0].Groups).Count -ne 1 -or
      $content[0].Value[0].Groups[0].Operator -ne 'Or') {
    throw 'Advanced rule is not the expected external-sharing AND classifier expression.'
  }
  $accessScope = [string]$access[0].Value
  $classifiers = @($content[0].Value[0].Groups[0].Sensitivetypes)
}
$recipients = @($confirmed.GenerateAlert)
if (-not $confirmed.BlockAccess -or $confirmed.Disabled -or
    [string]$confirmed.BlockAccessScope -ne 'All' -or
    $accessScope -ne 'NotInOrganization' -or $overrides.Count -ne 0 -or
    $classifiers.Count -ne 1 -or $classifiers[0].name -ne 'Credit Card Number' -or
    [int]$classifiers[0].mincount -ne 1 -or [int]$classifiers[0].minconfidence -ne 85 -or
    $recipients.Count -ne 1 -or [string]$recipients[0] -ne $AlertRecipient) {
  throw 'Strict rule, classifier, and alert recipient were not confirmed. Policy mode was not changed.'
}
Set-DlpCompliancePolicy -Identity $policyName -Mode $Mode -ErrorAction Stop
$saved = Get-DlpCompliancePolicy -Identity $policyName -DistributionDetail
if ([string]$saved.Mode -ne $Mode) { throw 'The requested policy mode was not saved.' }
$saved
Get-DlpComplianceRule -Identity $ruleName
