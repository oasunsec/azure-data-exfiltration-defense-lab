# Purview DLP test

**Sample uses synthetic financial data only.**

I scoped **Data Defense Lab - Financial external access** to the dedicated SharePoint lab site. Its rule, **Data Defense Lab - Strict financial access restriction**, matches at least one Credit Card Number at high confidence (85) when content is shared outside the organization.

The action blocks access except for the owner, last modifier, and site administrator. User overrides are disabled. The [PowerShell script](scripts/configure_dlp.ps1) requires an SMTP address in `AlertRecipient` and checks the saved recipient, scope, classifier, block action, and override settings before enabling the policy.

## Test results

| Test | Result | Evidence |
| --- | --- | --- |
| Synthetic classifier input | One Credit Card Number match at confidence 65, 75, and 85 | [Classifier response](docs/evidence/public/dlp-classifier-test.json) |
| Anonymous-link request for financial file and nonsensitive control | Both rejected with `sharingDisabled`; no link created | [Sharing responses](docs/evidence/public/sharing-control-test.json) |
| Strict rule readback | Block enabled, one site, confidence 85, no overrides | [Readiness check](docs/evidence/public/dlp-strict-readiness.json) |
| Content-specific file enforcement | NOT VALIDATED | No qualifying DLP block event collected |

The original requests attempted anonymous links. An authenticated SharePoint readback later confirmed that the lab site already permits authenticated guest sharing (`ExternalUserSharingOnly`); no sharing change was needed. The classifier response confirms a text match, not enforcement on a SharePoint file. At the September 8, 18:21 UTC check, policy distribution was Pending and the earlier rule was PendingDeletion. No guest test ran. The alert recipient was corrected in the portal; API readback confirmed the dedicated lab administrator and zero overrides.

A controlled external guest test must establish that the nonsensitive file is accessible while the financial file is restricted by this rule. The external test account must not be an exempt owner. Any temporary site-sharing change and guest file permissions are removed after the test.

Activity Explorer returned no records in the queried 24-hour window. [Query result](docs/evidence/public/dlp-activity-query.json).

The earlier rule export remains in [baseline evidence](docs/evidence/public/dlp-rule.json). It used an external-user block; a later readback found a FalsePositive override. The strict replacement avoids that override. The old rule is awaiting service-side deletion. In Microsoft's [cmdlet reference](https://learn.microsoft.com/en-us/powershell/module/exchangepowershell/set-dlpcompliancerule?view=exchange-ps), `NotifyAllowOverride` is an enum array, not a Boolean.
