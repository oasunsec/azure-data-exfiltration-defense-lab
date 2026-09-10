# Azure Data Exfiltration Defense Lab

I tested storage, identity, and detection controls around a dedicated financial-records container and SharePoint site.

**Sample uses synthetic financial data only.**

## Architecture

```mermaid
flowchart LR
  I[Scoped Entra workloads] --> S[Azure Blob Storage]
  N[IP firewall and Azure Policy] --> S
  S --> L[StorageBlobLogs]
  A[Azure Activity] --> W[Log Analytics]
  E[Entra sign-ins] --> W
  L --> W
  W --> Q[Sentinel alert and investigation]
  F[Financial document] --> P[Separate SharePoint and Purview test]
```

## Controls tested

| Control | Result |
| --- | --- |
| Scoped RBAC | Reader downloaded the file but could not overwrite it. Contributor uploaded data but could not grant roles. |
| Storage access | Anonymous and shared-key requests were rejected. Removing the allowed IP blocked an authorized reader; restoring it restored access. |
| Azure Policy | Public-blob enablement was rejected. The classification audit passed after I added the required tag. |
| MFA | Password-only authentication succeeded in report-only mode and failed when the lab MFA policy was enabled. |
| Sentinel | A denied write produced a native Medium alert and incident. |
| Investigation | I correlated three denied reads with preceding changes on the same storage account. |
| SharePoint DLP | In the fresh post-audit run at 20:34:58 UTC, an authenticated guest opened the nonsensitive control file; the synthetic financial file was blocked by an organizational-policy page. Purview telemetry did not identify the strict rule. |
| Isolated Purview simulation | A site-scoped diagnostic policy matched `Financial_Records_CONFIDENTIAL.docx` on the unique `LAB-FIN-########` classifier in Simulation; enforcement is still pending. |

## Evidence

[Portal captures and API results](docs/evidence/public/README.md) · [Control matrix](CONTROL_MATRIX.md) · [Validation](VALIDATION.md) · [Architecture](ARCHITECTURE.md) · [KQL](docs/kql/README.md) · [Bicep](infra/)

## What remains

The fresh post-audit guest run demonstrated an access restriction, but the page and the subsequent Purview queries did not identify the historical strict rule or an enforcement action. The isolated simulation path now has an attributable match and is being carried through enforcement separately. The [Purview record](PURVIEW_DLP.md) keeps those results distinct. Defender endpoint correlation and USB/Bluetooth controls remain outside the tested release.

A blocked request does not prove every exfiltration path is closed. Authorized downloads remain possible, and resource/time correlation does not identify a person. [Limitations](LIMITATIONS.md) lists the remaining boundaries.

## Related project

**Lab state: RETAINED FOR CONTINUED VALIDATION.**
