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
| Authenticated guest control file | Accessible after audit ingestion was enabled | [Post-audit behavior](docs/evidence/public/dlp-post-audit-test.json) |
| Authenticated guest financial file | Blocked by an organizational-policy access-denied page; the page did not name a DLP rule | [Post-audit behavior](docs/evidence/public/dlp-post-audit-test.json) |
| Fresh authenticated guest comparison | At 20:34:58 UTC, control file accessible; financial file blocked by the same organizational-policy page | [Fresh behavior](docs/evidence/public/dlp-fresh-guest-test.json) |
| Authoritative DLP telemetry | NOT VALIDATED | Fresh Activity Explorer query returned zero rows; Unified Audit returned no usable result with a `BadRequest` warning; available DLP reports returned zero rows |

The original requests attempted anonymous links and were rejected by the site sharing boundary. An authenticated SharePoint readback confirmed that the lab site already permits authenticated guest sharing (`ExternalUserSharingOnly`); no sharing change was needed. After unified audit ingestion was enabled, the guest opened the control file and the financial file returned the organizational-policy block page. The page did not name the Purview policy or rule. The fresh policy readback reports distribution `Success`; the earlier rule remains `PendingDeletion`. The alert recipient matches the dedicated lab administrator and overrides remain disabled. The guest, item permissions, and temporary Purview roles were removed after the run.

A controlled external guest test must establish that the nonsensitive file is accessible while the financial file is restricted by this rule. The external test account must not be an exempt owner. Any temporary site-sharing change and guest file permissions are removed after the test. The fresh comparison met the behavioral condition, but no authoritative record named the rule or action.

Activity Explorer and the available DLP reports returned no record naming the strict rule in the post-audit window. Exchange Online audit search also returned no usable record and a `BadRequest` warning. [Fresh telemetry](docs/evidence/public/dlp-fresh-guest-telemetry.json). This is a telemetry gap, not proof that the access-denied page was or was not caused by Purview.

The earlier rule export remains in [baseline evidence](docs/evidence/public/dlp-rule.json). It used an external-user block; a later readback found a FalsePositive override. The strict replacement avoids that override. The old rule is awaiting service-side deletion. In Microsoft's [cmdlet reference](https://learn.microsoft.com/en-us/powershell/module/exchangepowershell/set-dlpcompliancerule?view=exchange-ps), `NotifyAllowOverride` is an enum array, not a Boolean.
