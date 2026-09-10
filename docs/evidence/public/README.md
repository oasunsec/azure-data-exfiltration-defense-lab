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
| [Storage/RBAC requests](storage-rbac-tests.json) | Allowed reads/uploads and rejected write/grant/key/anonymous tests |
| [Configuration check](storage-configuration-check.json) | Saved ARM response passed the baseline checks |
| [Firewall behavior](firewall-test.json) | Read allowed, then denied, then restored |
| [Policy compliance](policy-compliance.json) | Classification remediation and custom-policy results |
| [Identity sign-ins](identity-signins.json) | Report-only success and enforced MFA rejection |
| [Sharing control](sharing-control-test.json) | Anonymous-link requests rejected for both files by the site boundary |
| [Site sharing configuration](sharepoint-sharing-configuration.json) | Authenticated guest sharing already enabled; anonymous sharing disabled; no site change needed |
| [Isolated DLP simulation](dlp-isolated-simulation.json) | The site-scoped lab policy matched the synthetic financial file in Simulation with the custom classifier; enforcement was not inferred from this record |
| [Isolated DLP enforcement](dlp-isolated-enforcement.json) | Activity Explorer and Unified Audit name the isolated policy, rule, classifier, file, and `BlockAccess`; the later guest comparison is recorded separately without claiming direct event correlation |
| [Isolated DLP disable readback](dlp-isolated-disable-readback.json) | The diagnostic policy was disabled after validation and reached distribution `Success`; the rule artifact remains retained |
| [Isolated simulation detail](dlp-isolated-simulation-detail.png) | Sanitized Purview detail pane showing the simulation match and notification actions |
| [Isolated enforcement detail](dlp-isolated-enforcement-detail.png) | Sanitized Purview detail pane showing the enforcement match and `BlockAccess` |
| [Isolated classifier detail](dlp-isolated-sit-detail.png) | Sanitized Purview classifier pane showing one `Lab Financial Record ID` match at high confidence |
| [Isolated alert policy](dlp-isolated-alert-policy.png) | Sanitized Purview alert pane naming the isolated policy, rule, financial file, and notification actions |
| [Isolated guest control](dlp-isolated-control.png) | Sanitized control-file result from the external lab guest |
| [Isolated guest financial block](dlp-isolated-financial-block.png) | Sanitized financial-file organizational-policy block page from the external lab guest |
| [Current cleanup](dlp-pass-cleanup.json) | Temporary compliance role removed; workload secrets zero; sharing unchanged |
| [Cross-source correlation](cross-source-correlation.json) | Three matching account-change/denied-access pairs |
| [Sentinel trigger](sentinel-trigger.json) | Real 403 write used for the native detection |
| [Sentinel incident](sentinel-incident.json) | Native Medium incident 19 |
| [DLP policy state](dlp-policy-state.json) | Policy mode and observed distribution state |
| [Endpoint readiness](endpoint-readiness.json) | Current Defender and Azure VM inventory; no dedicated lab endpoint |
| [Defender inventory](defender-inventory.json) | No onboarded machines available for endpoint tests |
| [Credential cleanup](credential-cleanup.json) | Both workload identities have zero password credentials |
| [Temporary-role cleanup](temporary-role-cleanup.json) | The lab-created compliance elevation was removed |
| [Teardown readback](teardown-readback.json) | Dedicated Azure resources, lab ingestion feeds, policy objects, roles, and Sentinel analytic removed; retained objects classified |
| [Release checks](release-checks.json) | Tests, compiled templates, privacy check, and secret-scan results |

Each result describes the tested operation. See [limitations](../../../LIMITATIONS.md) for investigation and attribution boundaries.
