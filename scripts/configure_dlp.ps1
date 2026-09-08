param(
  [Parameter(Mandatory)][uri]$LabSiteUrl,
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
$ruleName = 'Data Defense Lab - Credit card external access block'
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
    -AccessScope NotInOrganization -BlockAccess $true -BlockAccessScope PerUser `
    -NotifyUser LastModifier -NotifyAllowOverride $false -GenerateAlert $true -ErrorAction Stop | Out-Null
}
$confirmed = Get-DlpComplianceRule -Identity $ruleName -ErrorAction Stop
if (-not $confirmed.BlockAccess -or $confirmed.Disabled) { throw 'Active block rule was not confirmed.' }
Set-DlpCompliancePolicy -Identity $policyName -Mode $Mode -ErrorAction Stop
Get-DlpCompliancePolicy -Identity $policyName -DistributionDetail
Get-DlpComplianceRule -Identity $ruleName
