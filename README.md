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

## Evidence

[Portal captures and API results](docs/evidence/public/README.md) · [Control matrix](CONTROL_MATRIX.md) · [Validation](VALIDATION.md) · [Architecture](ARCHITECTURE.md) · [KQL](docs/kql/README.md) · [Bicep](infra/)

## What remains

Content-specific SharePoint DLP enforcement remains unproven. The original sharing test stopped at the site's sharing restriction. The [Purview record](PURVIEW_DLP.md) tracks the strict rule and subsequent checks. Defender endpoint correlation and USB/Bluetooth controls remain outside the tested release.

A blocked request does not prove every exfiltration path is closed. Authorized downloads remain possible, and resource/time correlation does not identify a person. [Limitations](LIMITATIONS.md) lists the remaining boundaries.

## Related project

[Honey Token Detection](https://github.com/oasunsec/honey-token-detection) records a separate document-access signal. The two projects have separate test evidence.

**Lab state: RETAINED FOR CONTINUED VALIDATION.**
