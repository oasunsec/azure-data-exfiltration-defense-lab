# Control validation matrix

| Control | Implementation | Actual test and result | Evidence | Status |
| --- | --- | --- | --- | --- |
| Encryption at rest | Microsoft-managed storage encryption and infrastructure encryption | ARM and portal confirmed enabled; no cryptographic forensic test | [Configuration check](docs/evidence/public/storage-configuration-check.json), [portal](docs/evidence/public/02-encryption.png) | CONFIGURATION VERIFIED |
| HTTPS / TLS | Secure transfer required; minimum TLS 1.2 | ARM and portal matched baseline | [Portal](docs/evidence/public/01-storage-controls.png) | CONFIGURATION VERIFIED |
| Anonymous access | Account disallows public blobs; private container | Anonymous read rejected: 409 PublicAccessNotPermitted | [API tests](docs/evidence/public/storage-rbac-tests.json) | VALIDATED |
| Shared keys | Shared-key data authorization disabled | Real key rejected: 403 KeyBasedAuthenticationNotPermitted | [API tests](docs/evidence/public/storage-rbac-tests.json) | VALIDATED |
| Network boundary | Default deny, one operator IP, no trusted-service bypass | Authorized OAuth reader: success, 403 outside allowlist, success after restore | [Behavioral test](docs/evidence/public/firewall-test.json), [portal](docs/evidence/public/03-network-boundary.png) | VALIDATED |
| Reader | Reader on lab RG; Blob Data Reader on container | Read succeeded; account change and blob overwrite rejected | [RBAC tests](docs/evidence/public/storage-rbac-tests.json) | VALIDATED |
| Contributor | Contributor on lab RG; Blob Data Contributor on container | Account change/upload succeeded; role assignment rejected | [RBAC tests](docs/evidence/public/storage-rbac-tests.json) | VALIDATED |
| Azure Policy deny | Deny public blob access, lab RG only | Attempt to enable public blob access rejected by policy | [API tests](docs/evidence/public/storage-rbac-tests.json) | VALIDATED |
| Azure Policy audit | Require Confidential classification tag | Noncompliant before tag; compliant after remediation | [Policy results](docs/evidence/public/policy-compliance.json) | VALIDATED |
| MFA | One included lab user; administrator exclusions | Password grant succeeded in report-only mode; enforced policy rejected it | [Sign-ins](docs/evidence/public/identity-signins.json) | VALIDATED |
| Cloud sharing | Dedicated private SharePoint site | Anonymous links rejected for sensitive and control files: sharingDisabled | [Sharing tests](docs/evidence/public/sharing-control-test.json) | VALIDATED SITE RESTRICTION |
| Purview DLP | Isolated synthetic identifier, site-scoped rule, no override; historical credit-card rule retained separately | Simulation matched the exact financial file, then the same rule reached `Enable`/`Success`; Activity Explorer and Unified Audit named the isolated policy, rule, classifier, and `BlockAccess`; the control file opened and the financial file was blocked. The older credit-card path and `PendingDeletion` rule remain historical evidence. | [Isolated enforcement](docs/evidence/public/dlp-isolated-enforcement.json), [simulation](docs/evidence/public/dlp-isolated-simulation.json), [alert capture](docs/evidence/public/dlp-isolated-alert-policy.png), [guest comparison](docs/evidence/public/dlp-isolated-control.png) | VALIDATED |
| Cross-source investigation | AzureActivity + StorageBlobLogs | Three resource/time matches after account changes | [Results](docs/evidence/public/cross-source-correlation.json) | VALIDATED |
| Sentinel analytic | Medium denied-write rule; resource-based grouping | Rejected write produced native Medium incident 19 | [Sentinel](SENTINEL.md) | VALIDATED |
| Resource retention | CanNotDelete RG lock | Lock deployed; no destructive deletion test | [Bicep](infra/main.bicep) | CONFIGURATION VERIFIED |
| Endpoint DLP / USB | No onboarded test endpoint or USB test device | No endpoint enforcement exercised | [Endpoint scope](DEFENDER.md) | NOT VALIDATED |
| Defender endpoint correlation | License available; machine inventory empty | No process/file/network event available | [Defender](DEFENDER.md) | NOT VALIDATED |

The configuration-only rows were checked through ARM and the portal. Behavioral rows link actual requests and results. Other inherited policy findings remain outside the two custom-policy tests.
