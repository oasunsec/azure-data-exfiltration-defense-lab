# Purview DLP test

**Sample uses synthetic financial data only.**

I scoped **Data Defense Lab - Financial external access** to the dedicated SharePoint lab site. Its rule, **Data Defense Lab - Strict financial access restriction**, matches at least one Credit Card Number at high confidence (85) when content is shared outside the organization.

The action blocks access except for the owner, last modifier, and site administrator. User overrides are disabled. The [PowerShell script](scripts/configure_dlp.ps1) checks the saved scope, classifier, block action, and override settings before enabling the policy.

## Test results

| Test | Result | Evidence |
| --- | --- | --- |
| Synthetic classifier input | One Credit Card Number match at confidence 65, 75, and 85 | [Classifier response](docs/evidence/public/dlp-classifier-test.json) |
| Anonymous-link request for financial file and nonsensitive control | Both rejected with `sharingDisabled`; no link created | [Sharing responses](docs/evidence/public/sharing-control-test.json) |
| Strict rule readback | Block enabled, one site, confidence 85, no overrides | [Readiness check](docs/evidence/public/dlp-strict-readiness.json) |
| Content-specific file enforcement | NOT VALIDATED | No qualifying DLP block event collected |

The original sharing restriction stopped both files before their content could make a difference. The classifier response confirms a text match, not enforcement on a SharePoint file. The strict rule's latest distribution state is recorded in the readiness check; sharing tests require successful distribution. At the final check, distribution was Pending and the earlier rule was PendingDeletion. SharePoint PowerShell authentication did not complete, so site sharing remained unchanged and no guest permissions were created.

A controlled external guest test must establish that the nonsensitive file is accessible while the financial file is restricted by this rule. The external test account must not be an exempt owner. Any temporary site-sharing change and guest file permissions are removed after the test.

Activity Explorer returned no records in the queried 24-hour window. [Query result](docs/evidence/public/dlp-activity-query.json).

The earlier rule export remains in [baseline evidence](docs/evidence/public/dlp-rule.json). It used an external-user block; a later readback found a FalsePositive override. The strict replacement avoids that override. The old rule is awaiting service-side deletion. In Microsoft's [cmdlet reference](https://learn.microsoft.com/en-us/powershell/module/exchangepowershell/set-dlpcompliancerule?view=exchange-ps), `NotifyAllowOverride` is an enum array, not a Boolean.
