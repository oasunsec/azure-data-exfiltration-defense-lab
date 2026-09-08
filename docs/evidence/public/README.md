# Public evidence

**All financial data used in this lab is synthetic test data.**

Screenshots are genuine portal captures cropped to the relevant controls. JSON contains selected fields from actual API or KQL results; it is not presented as a portal screenshot. Private identifiers are omitted or replaced with lab aliases.

| Evidence | Observed result |
| --- | --- |
| [Storage controls](01-storage-controls.png) | Anonymous access and shared keys disabled; TLS 1.2; infrastructure encryption enabled |
| [Encryption](02-encryption.png) | Microsoft-managed keys and infrastructure encryption |
| [Network boundary](03-network-boundary.png) | Selected networks, one IPv4 allow entry, no exceptions |
| [Storage/RBAC requests](storage-rbac-tests.json) | Allowed reads/uploads and rejected write/grant/key/anonymous tests |
| [Configuration check](storage-configuration-check.json) | Saved ARM response passed the baseline checks |
| [Firewall behavior](firewall-test.json) | Read allowed, then denied, then restored |
| [Policy compliance](policy-compliance.json) | Classification remediation and custom-policy results |
| [Identity sign-ins](identity-signins.json) | Report-only success and enforced MFA rejection |
| [Sharing control](sharing-control-test.json) | Both files rejected by the site restriction |
| [DLP rule](dlp-rule.json) | External-access block configured; not enforcement proof |
| [Classifier test](dlp-classifier-test.json) | Credit Card Number matched synthetic text; not a file-enforcement test |
| [Cross-source correlation](cross-source-correlation.json) | Three matching account-change/denied-access pairs |
| [Sentinel trigger](sentinel-trigger.json) | Real 403 write used for the native detection |
| [Sentinel incident](sentinel-incident.json) | Native Medium incident 19 |
| [DLP policy state](dlp-policy-state.json) | Policy mode and observed distribution state |
| [Defender inventory](defender-inventory.json) | No onboarded machines available for endpoint tests |

The site restriction cannot be presented as a DLP content match. The cross-source join cannot establish who accessed the file. Additional screenshots are included only after comparison with the API evidence.
