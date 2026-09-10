# Public evidence

**All financial data used in this lab is synthetic test data.**

Screenshots are genuine portal captures cropped to the relevant controls. JSON contains selected fields from actual API or KQL results; it is not presented as a portal screenshot. Private identifiers are omitted or replaced with lab aliases.

| Evidence | Observed result |
| --- | --- |
| [Storage controls](01-storage-controls.png) | Anonymous access and shared keys disabled; TLS 1.2; infrastructure encryption enabled |
| [Encryption](02-encryption.png) | Microsoft-managed keys and infrastructure encryption |
| [Network boundary](03-network-boundary.png) | Selected networks, one IPv4 allow entry, no exceptions |
| [MFA policy](04-mfa-policy.png) | On, one included user, administrator exclusions, MFA required |
| [MFA rejection](05-mfa-signin-result.png) | Actual sign-in error 50079 and MFA requirement; request identifiers redacted |
| [Policy evaluation](05b-mfa-policy-result.png) | The lab policy returned Failure for that sign-in |
| [Strict DLP rule](06-purview-strict-rule.png) | Enabled rule, external-sharing condition, and restriction summary |
| [DLP classifier and action](06b-purview-classifier-action.png) | Credit Card Number, high confidence, minimum 1, and Block everyone |
| [DLP site scope](06c-purview-site-scope.png) | SharePoint selected with one site; other listed workloads unselected |
| [Storage/RBAC requests](storage-rbac-tests.json) | Allowed reads/uploads and rejected write/grant/key/anonymous tests |
| [Configuration check](storage-configuration-check.json) | Saved ARM response passed the baseline checks |
| [Firewall behavior](firewall-test.json) | Read allowed, then denied, then restored |
| [Policy compliance](policy-compliance.json) | Classification remediation and custom-policy results |
| [Identity sign-ins](identity-signins.json) | Report-only success and enforced MFA rejection |
| [Sharing control](sharing-control-test.json) | Anonymous-link requests rejected for both files by the site boundary |
| [Historical post-audit guest behavior](dlp-post-audit-test.json) | Earlier credit-card-path control file opened; financial file returned a generic organizational-policy page |
| [Historical post-audit telemetry](dlp-post-audit-telemetry.json) | The earlier path did not name the historical strict DLP rule; it is retained as a limitation record |
| [Historical fresh guest behavior](dlp-fresh-guest-test.json) | Earlier credit-card-path comparison; the page did not name a rule |
| [Historical fresh screenshots](dlp-fresh-rerun2-control.png, dlp-fresh-rerun2-financial-block.png) | Redacted crops from the earlier credit-card-path comparison |
| [Historical fresh telemetry](dlp-fresh-guest-telemetry.json) | Earlier query window and service warnings; not used for the isolated validation conclusion |
| [Fresh guest cleanup](dlp-fresh-guest-cleanup.json) | Guest, item permissions, and temporary site administration removed; original sharing and DLP settings preserved |
| [Post-audit cleanup](dlp-post-audit-cleanup.json) | Guest, item permissions, orphan site user, and temporary administration removed; sharing and DLP rules unchanged |
| [Original DLP rule](dlp-rule.json) | Earlier external-user rule, retained as baseline evidence |
| [DLP alert readback](dlp-alert-readback.json) | Corrected recipient confirmed; block all, zero overrides; fresh policy distribution readback is Success |
| [Site sharing configuration](sharepoint-sharing-configuration.json) | Authenticated guest sharing already enabled; anonymous sharing disabled; no site change needed |
| [Strict DLP readiness](dlp-strict-readiness.json) | Single-site scope, high-confidence classifier, strict block, no overrides, distribution state |
| [Read-only access diagnostic](dlp-access-diagnostic.json) | Current permissions, guest sign-in, and unresolved alternative causes |
| [DLP policy diagnostic](dlp-policy-diagnostic.json) | Current policy/rule comparison, item-level `Test-DlpPolicies` results, and the SharePoint access-denied inspection result |
| [Isolated DLP simulation](dlp-isolated-simulation.json) | The site-scoped lab policy matched the synthetic financial file in Simulation with the custom classifier; enforcement was not inferred from this record |
| [Isolated DLP enforcement](dlp-isolated-enforcement.json) | Activity Explorer and Unified Audit name the isolated policy, rule, classifier, and `BlockAccess`; the control opened and the financial file was blocked |
| [Isolated DLP disable readback](dlp-isolated-disable-readback.json) | The diagnostic policy was disabled after validation and reached distribution `Success`; the rule artifact remains retained |
| [Isolated simulation detail](dlp-isolated-simulation-detail.png) | Sanitized Purview detail pane showing the simulation match and notification actions |
| [Isolated enforcement detail](dlp-isolated-enforcement-detail.png) | Sanitized Purview detail pane showing the enforcement match and `BlockAccess` |
| [Isolated classifier detail](dlp-isolated-sit-detail.png) | Sanitized Purview classifier pane showing one `Lab Financial Record ID` match at high confidence |
| [Isolated alert policy](dlp-isolated-alert-policy.png) | Sanitized Purview alert pane naming the isolated policy, rule, financial file, and notification actions |
| [Isolated guest control](dlp-isolated-control.png) | Sanitized control-file result from the external lab guest |
| [Isolated guest financial block](dlp-isolated-financial-block.png) | Sanitized financial-file organizational-policy block page from the external lab guest |
| [Activity Explorer query](dlp-activity-query.json) | Successful query with zero records in its 24-hour window |
| [Current cleanup](dlp-pass-cleanup.json) | Temporary compliance role removed; workload secrets zero; sharing unchanged |
| [Classifier test](dlp-classifier-test.json) | Credit Card Number matched synthetic text; not a file-enforcement test |
| [Cross-source correlation](cross-source-correlation.json) | Three matching account-change/denied-access pairs |
| [Sentinel trigger](sentinel-trigger.json) | Real 403 write used for the native detection |
| [Sentinel incident](sentinel-incident.json) | Native Medium incident 19 |
| [DLP policy state](dlp-policy-state.json) | Policy mode and observed distribution state |
| [Endpoint readiness](endpoint-readiness.json) | Current Defender and Azure VM inventory; no dedicated lab endpoint |
| [Defender inventory](defender-inventory.json) | No onboarded machines available for endpoint tests |
| [Credential cleanup](credential-cleanup.json) | Both workload identities have zero password credentials |
| [Temporary-role cleanup](temporary-role-cleanup.json) | The lab-created compliance elevation was removed |
| [Release checks](release-checks.json) | Tests, compiled templates, privacy check, and secret-scan results |

Each result describes the tested operation. See [limitations](../../../LIMITATIONS.md) for investigation and attribution boundaries.
