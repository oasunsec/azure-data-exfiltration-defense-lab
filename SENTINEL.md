# Sentinel detection and investigation

## Sources observed

`StorageBlobLogs`, `AzureActivity`, `SigninLogs`, and `AuditLogs` contained actual lab events. Storage resource logs used a dedicated table. The lab subscription Activity and Entra diagnostic settings routed to the existing workspace during validation; both lab-created feeds were removed during teardown.

## Native detection

**Financial records - denied blob write** was a scheduled analytic with Medium severity. It selected rejected PutBlob operations in the financial container. A controlled read-only workload generated a 403 AuthorizationPermissionMismatch; Sentinel produced a native scheduled alert and incident **19**, titled **Financial records - denied blob write**, with Medium severity. The dedicated analytic was deleted after its committed evidence was verified; the shared workspace was retained.

The alert identifies a rejected write, not exfiltration or malicious intent.

The rule runs every five minutes and groups incidents by the mapped storage resource over 24 hours. This avoids treating every matching row as a separate incident, but can combine different callers against that account. Reopening closed incidents is disabled. Repeat-incident grouping has not yet been behaviorally proven by a second alert.

## Investigation

The [cross-source query](docs/kql/storage-change-denied-access.kql) returned three denied reads after successful account changes. The join uses normalized resource ID and a five-minute window, choosing the closest preceding change for each request. The firewall test independently recorded authorized access, denial after allowlist removal, and restored access.

The MFA sign-in sequence is a separate controlled test. It was not the identity used for the workload's storage request. Purview and Defender were not joined into this incident. The connector inventory contained no Purview/Office 365 connector, so the isolated Purview validation is documented separately and no DLP-to-Sentinel correlation is claimed.

[Queries](docs/kql/README.md) · [Sanitized correlation](docs/evidence/public/cross-source-correlation.json) · [Detection trigger](docs/evidence/public/sentinel-trigger.json)
