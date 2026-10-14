# Control matrix

**Tested** means I ran a request and recorded the result. **Configured** means I checked the setting in ARM and the portal but did not attack it.

| Control | Setup | Test and result | Evidence | Status |
| --- | --- | --- | --- | --- |
| Encryption at rest | Microsoft-managed keys plus infrastructure encryption | Enabled in ARM and the portal | [Config check](evidence/public/storage-configuration-check.json), [portal](evidence/public/02-encryption.png) | Configured |
| HTTPS and TLS | Secure transfer required, TLS 1.2 minimum | Matched in ARM and the portal | [Portal](evidence/public/01-storage-controls.png) | Configured |
| Anonymous access | Public blobs disallowed, private container | Anonymous read rejected: 409 `PublicAccessNotPermitted` | [API tests](evidence/public/storage-rbac-tests.json) | Tested |
| Shared key | Shared-key data access disabled | Real key rejected: 403 `KeyBasedAuthenticationNotPermitted` | [API tests](evidence/public/storage-rbac-tests.json) | Tested |
| Network firewall | Default deny, one operator IP, no trusted-service bypass | Reader allowed, 403 once removed from the allowlist, allowed after restore | [Firewall test](evidence/public/firewall-test.json), [portal](evidence/public/03-network-boundary.png) | Tested |
| Reader | Reader on the resource group, Blob Data Reader on the container | Read worked; account change and overwrite rejected | [RBAC tests](evidence/public/storage-rbac-tests.json) | Tested |
| Contributor | Contributor on the resource group, Blob Data Contributor on the container | Account change and upload worked; role assignment rejected | [RBAC tests](evidence/public/storage-rbac-tests.json) | Tested |
| Policy: deny | Deny public blob access in the lab resource group | Enabling public blob access rejected | [API tests](evidence/public/storage-rbac-tests.json) | Tested |
| Policy: audit | Require a `Confidential` classification tag | Noncompliant before the tag, compliant after | [Policy results](evidence/public/policy-compliance.json) | Tested |
| MFA | One lab user included, admins excluded | Password-only sign-in worked in report-only mode, rejected when enforced | [Sign-ins](evidence/public/identity-signins.json) | Tested |
| SharePoint sharing | Dedicated private site | Anonymous links refused for both files (`sharingDisabled`) | [Sharing test](evidence/public/sharing-control-test.json) | Tested |
| Purview DLP | Custom classifier, site-scoped rule, no user override | Matched in simulation, then blocked in enforcement; records name the policy, rule, classifier and `BlockAccess`; control file opened, financial file blocked | [Enforcement](evidence/public/dlp-isolated-enforcement.json), [simulation](evidence/public/dlp-isolated-simulation.json), [alert](evidence/public/dlp-isolated-alert-policy.png), [guest result](evidence/public/dlp-isolated-control.png) | Tested |
| Investigation | AzureActivity joined with StorageBlobLogs | Three denied reads followed an account change within five minutes | [Results](evidence/public/cross-source-correlation.json) | Tested |
| Sentinel analytic | Medium rule on denied writes, grouped by resource | A rejected write raised incident 19 | [Sentinel](sentinel.md) | Tested |
| Delete lock | `CanNotDelete` lock on the resource group | Deployed; I did not try to delete through it | [Bicep](../infra/main.bicep) | Configured |
| Endpoint DLP and USB | No onboarded endpoint or USB test device | Not run | [Limitations](limitations.md#endpoint) | Not tested |
| Defender correlation | License available, no onboarded machines | No endpoint events to correlate | [Limitations](limitations.md#endpoint) | Not tested |

The earlier credit card DLP rule and its `PendingDeletion` leftover are described in [Purview DLP](purview-dlp.md#first-attempt-built-in-credit-card-classifier). They are not used as evidence for the result above.
