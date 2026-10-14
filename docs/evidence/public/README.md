# Evidence

**All financial data used in this lab is synthetic test data.**

Screenshots are real portal captures, cropped to the setting or result that matters, with identifiers blacked out. JSON files hold selected fields from real API and KQL results, with private identifiers removed or replaced by lab aliases.

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
| [Site sharing configuration](sharepoint-sharing-configuration.json) | Guest sharing on, anonymous sharing off; no site change needed |
| [Isolated DLP simulation](dlp-isolated-simulation.json) | The lab policy matched the synthetic financial file in simulation with the custom classifier |
| [Isolated DLP enforcement](dlp-isolated-enforcement.json) | Activity Explorer and Unified Audit name the policy, rule, classifier, file and `BlockAccess` |
| [Isolated DLP disable readback](dlp-isolated-disable-readback.json) | The policy was disabled after the test; the rule is kept |
| [Isolated simulation detail](dlp-isolated-simulation-detail.png) | Purview detail pane showing the simulation match and notification actions |
| [Isolated enforcement detail](dlp-isolated-enforcement-detail.png) | Purview detail pane showing the enforcement match and `BlockAccess` |
| [Isolated classifier detail](dlp-isolated-sit-detail.png) | Purview classifier pane showing one `Lab Financial Record ID` match at high confidence |
| [Isolated alert policy](dlp-isolated-alert-policy.png) | Purview alert pane naming the isolated policy, rule, financial file, and notification actions |
| [Isolated guest control](dlp-isolated-control.png) | The external guest could open the control file |
| [Isolated guest financial block](dlp-isolated-financial-block.png) | The external guest was blocked from the financial file |
| [Current cleanup](dlp-pass-cleanup.json) | Temporary compliance role removed; workload secrets zero; sharing unchanged |
| [Cross-source correlation](cross-source-correlation.json) | Three matching account-change/denied-access pairs |
| [Sentinel trigger](sentinel-trigger.json) | Real 403 write used for the native detection |
| [Sentinel incident](sentinel-incident.json) | Native Medium incident 19 |
| [DLP policy state](dlp-policy-state.json) | Policy mode and observed distribution state |
| [Endpoint readiness](endpoint-readiness.json) | Current Defender and Azure VM inventory; no dedicated lab endpoint |
| [Defender inventory](defender-inventory.json) | No onboarded machines available for endpoint tests |
| [Credential cleanup](credential-cleanup.json) | Both workload identities have zero password credentials |
| [Temporary-role cleanup](temporary-role-cleanup.json) | The lab-created compliance elevation was removed |
| [Teardown readback](teardown-readback.json) | Lab Azure resources, log feeds, policy objects, roles and the Sentinel analytic removed |
| [Release checks](release-checks.json) | Tests, compiled templates, privacy check, and secret-scan results |

Each result describes only the operation that was tested. See [limitations](../../limitations.md).
