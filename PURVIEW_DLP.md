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
| Authoritative DLP telemetry | NOT VALIDATED | The latest broad Unified Audit search returned 27 records, including control-file sharing and cleanup, but no strict-rule enforcement record. Activity Explorer returned only a default-policy DLP rule undo. The three DLP report cmdlets returned service-unavailable errors; those failures do not establish that records are absent. |
| Item-level policy diagnostic | Classifier detected; external-sharing flags false after cleanup; grouped strict-rule evaluation inconclusive | [Diagnostic comparison](docs/evidence/public/dlp-policy-diagnostic.json) |

The original requests attempted anonymous links and were rejected by the site sharing boundary. An authenticated SharePoint readback confirmed that the lab site already permits authenticated guest sharing (`ExternalUserSharingOnly`); no sharing change was needed. After unified audit ingestion was enabled, the guest opened the control file and the financial file returned the organizational-policy block page. The page did not name the Purview policy or rule. The fresh policy readback reports distribution `Success`; the earlier rule remains `PendingDeletion`. The alert recipient matches the dedicated lab administrator and overrides remain disabled. The guest, item permissions, and temporary Purview roles were removed after the run.

A controlled external guest test must establish that the nonsensitive file is accessible while the financial file is restricted by this rule. The external test account must not be an exempt owner. Any temporary site-sharing change and guest file permissions are removed after the test. The fresh comparison met the behavioral condition, but no authoritative record named the rule or action.

The latest broad Unified Audit search returned 27 records, including control-file sharing and cleanup, but no strict-rule enforcement record. Activity Explorer returned only a default-policy DLP rule undo. The three DLP report cmdlets returned service-unavailable errors; those failures do not establish that records are absent. [Fresh telemetry](docs/evidence/public/dlp-fresh-guest-telemetry.json). This is a telemetry gap, not proof that the access-denied page was or was not caused by Purview.

The later item-level diagnostic exported the current policy and rule objects. The custom rule is site-scoped, uses the saved external-sharing and high-confidence Credit Card Number conditions, blocks access except for the owner, last modifier, and site administrator, and has no user override. The tenant default policy covers all SharePoint and OneDrive locations but its two credit-card rules have no block action. The retired lab rule is still `PendingDeletion` and has no classifier condition in its saved `AdvancedRule`. `Test-DlpPolicies` reported no match or action and external-sharing flags were false after cleanup. The strict rule uses grouped/nested AdvancedRule conditions, which Test-DlpPolicies does not support. Its reported IsMatched=false is inconclusive for that rule; it does not establish whether the earlier guest block was caused by DLP. The lab administrator could not open the item or library in SharePoint, so no policy tip was available. These results do not establish DLP enforcement.

The earlier rule export remains in [baseline evidence](docs/evidence/public/dlp-rule.json). It used an external-user block; a later readback found a FalsePositive override. The strict replacement avoids that override. The old rule is awaiting service-side deletion. In Microsoft's [cmdlet reference](https://learn.microsoft.com/en-us/powershell/module/exchangepowershell/set-dlpcompliancerule?view=exchange-ps), `NotifyAllowOverride` is an enum array, not a Boolean.

Microsoft documents the [simple-condition limitation of Test-DlpPolicies](https://learn.microsoft.com/en-us/purview/dlp-test-dlp-policies). The [access diagnostic](docs/evidence/public/dlp-access-diagnostic.json) separates current permissions from the earlier guest test. No retest or rule change was made during this pass.

The subsequent user-provided Details captures show both files as not shared, with no visible DLP warning or policy tip. The financial file has an empty Sensitivity field; the control captures do not display it. This post-cleanup state does not attribute the earlier block. The observations are recorded in the [access diagnostic](docs/evidence/public/dlp-access-diagnostic.json); original captures remain private.
