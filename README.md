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
| SharePoint DLP | The isolated site-scoped policy matched `Lab Financial Record ID` in Simulation and reached enforcement distribution `Success`. Activity Explorer and Unified Audit independently recorded the exact policy, rule, file, classifier, and `BlockAccess`. A subsequent guest comparison opened the control file and blocked the financial file; no direct correlation between the 20:24 telemetry and the 20:30 guest requests is claimed. |

## Evidence

[Portal captures and API results](docs/evidence/public/README.md) · [Control matrix](CONTROL_MATRIX.md) · [Validation](VALIDATION.md) · [Architecture](ARCHITECTURE.md) · [KQL](docs/kql/README.md) · [Bicep](infra/)

## What remains

The 20:24 UTC Purview records prove the isolated policy matched the financial file and carried the `BlockAccess` action. The 20:30 UTC guest comparison is subsequent behavioral validation, kept separate because direct event correlation was not established. The historical `PendingDeletion` rule remains a cleanup issue. Defender endpoint correlation and USB/Bluetooth controls remain outside the tested release.

A blocked request does not prove every exfiltration path is closed. Authorized downloads remain possible, and resource/time correlation does not identify a person. [Limitations](LIMITATIONS.md) lists the remaining boundaries.

## Related project

**Lab state: RETAINED FOR CONTINUED VALIDATION.**
