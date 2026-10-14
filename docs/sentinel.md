# Sentinel detection and investigation

## Log sources

`StorageBlobLogs`, `AzureActivity`, `SigninLogs` and `AuditLogs` all received lab events. Storage logs went to their own table. The lab's subscription Activity and Entra diagnostic settings sent logs to an existing workspace during the test and were removed at teardown.

## Detection

**Financial records - denied blob write** was a scheduled Medium analytic that looked for rejected `PutBlob` operations on the financial container. I had the read-only identity try a write. It got a 403 `AuthorizationPermissionMismatch`, and Sentinel raised a native alert and incident **19** with Medium severity. I deleted the analytic after capturing that; the workspace was kept.

The alert means a write was refused. It does not mean data left, or that anyone meant harm.

The rule runs every five minutes and groups incidents by storage account over 24 hours, so one noisy account does not create an incident per row. The trade-off is that different callers against the same account can land in one incident. Closed incidents are not reopened. I did not trigger a second alert to test the grouping.

## Investigation

The [correlation query](kql/storage-change-denied-access.kql) found three denied reads that came after successful changes to the same account. It joins on the storage resource ID within five minutes and picks the closest earlier change for each request. The firewall test separately recorded access allowed, denied after the IP was removed, and allowed again.

The MFA sign-in was a separate test and was not the identity used for these storage requests. Purview and Defender events were not part of this incident: the workspace had no Purview or Office 365 connector, so the DLP result is documented on its own in [Purview DLP](purview-dlp.md).

[Queries](kql/README.md) · [correlation result](evidence/public/cross-source-correlation.json) · [detection trigger](evidence/public/sentinel-trigger.json)
