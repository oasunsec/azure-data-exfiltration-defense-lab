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
| [Sharing control](sharing-control-test.json) | Anonymous-link requests rejected for both files; authenticated guest access was not tested |
| [Original DLP rule](dlp-rule.json) | Earlier external-user rule, retained as baseline evidence |
| [DLP alert readback](dlp-alert-readback.json) | Corrected recipient confirmed; block all, zero overrides; distribution still Pending |
| [Site sharing configuration](sharepoint-sharing-configuration.json) | Authenticated guest sharing already enabled; anonymous sharing disabled; no site change needed |
| [Strict DLP readiness](dlp-strict-readiness.json) | Single-site scope, high-confidence classifier, strict block, no overrides, distribution state |
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
