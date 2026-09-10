# Cost-safe teardown

**Final lab state: AZURE TEARDOWN COMPLETE; MICROSOFT 365 EVIDENCE ARTIFACTS RETAINED.**

The successful evidence was committed and pushed before teardown. `DELETE_BILLABLE` identifies dedicated Azure resources or redeployable Azure components removed with the lab. `KEEP_FREE` identifies retained objects with no separate metered Azure resource in the observed state. `REVIEW` identifies shared or licensed tenant objects that require an owner decision. These classifications do not claim that Microsoft 365 licensing or shared Log Analytics ingestion is free.

## Inventory and disposition

| Resource or object | Classification | Final disposition |
| --- | --- | --- |
| Dedicated Azure resource group, Standard LRS storage account, private `financial-records` container, blob versions/soft-delete state, and blob diagnostic setting | `DELETE_BILLABLE` | Deleted; the resource group and all contained resources read back absent. |
| Five lab-scoped Azure role assignments: management Reader/Contributor, container Blob Data Reader/Contributor, and temporary operator Reader | `DELETE_BILLABLE` | Deleted before the resource group; no assignment remains at the removed scope. |
| Resource-group `CanNotDelete` lock | `DELETE_BILLABLE` | Removed deliberately to permit teardown. |
| Two resource-group Azure Policy assignments and two lab-only custom policy definitions | `DELETE_BILLABLE` | Deleted; definitions read back absent. |
| Lab subscription Activity diagnostic setting | `DELETE_BILLABLE` | Deleted; only the pre-existing subscription diagnostic setting remains. |
| Lab Entra identity diagnostic setting | `DELETE_BILLABLE` | Deleted; its AuditLogs and sign-in streams no longer ingest into the shared workspace. |
| Lab Sentinel analytic **Financial records - denied blob write** in the shared workspace | `DELETE_BILLABLE` | Deleted after its alert and incident evidence was committed. |
| Isolated Purview policy **Data Defense Lab - Isolated Financial ID Validation** and rule **Data Defense Lab - Lab Financial Record ID** | `KEEP_FREE` | Retained disabled; final distribution readback is `Success`. |
| Custom sensitive information type **Lab Financial Record ID** | `KEEP_FREE` | Retained as the reproducible synthetic classifier. |
| Dedicated SharePoint lab site, financial sample, and control file | `KEEP_FREE` | Retained under the existing Microsoft 365 tenant for evidence review and reproduction. |
| Three lab app registrations and service principals | `KEEP_FREE` | Retained credential-free; every app has zero password credentials and zero key credentials. |
| Scoped Conditional Access policy and sign-in test application | `KEEP_FREE` | Retained as identity-control evidence; the policy remains limited to the dedicated lab user. |
| Microsoft 365 unified audit ingestion | `KEEP_FREE` | Retained enabled as the tenant audit pipeline used for the authoritative DLP record. |
| Dedicated lab user with one assigned Microsoft 365 license | `REVIEW` | Retained for owner review; reclaiming or cancelling a license is a tenant subscription decision outside this Azure teardown. |
| Historical strict Purview rule and stale `PendingDeletion` rule | `REVIEW` | Preserved unchanged. The stale object remains a separate Purview cleanup issue; no deletion retry or force deletion was used. |
| Existing `canarysec-law` and `law-sc500-day06` Log Analytics workspaces | `REVIEW` | Retained because they are shared, pre-existing resources used by other projects. The data already ingested remains subject to their retention and billing settings. |
| Pre-existing `diag-subscription-to-law` subscription diagnostic setting | `REVIEW` | Retained unchanged because it predates this lab and targets the other shared workspace. |

No endpoint VM existed in the inventory, so there was no compute resource to delete.

## Verification

The final Azure readback at `2026-09-10T22:51:33Z` reported:

- dedicated resource group absent;
- zero Azure resources and zero role assignments under the deleted lab scope;
- lab subscription and Entra diagnostic settings absent;
- lab Sentinel analytic absent;
- lab Azure Policy definitions absent;
- both shared workspace resource groups still present;
- the pre-existing subscription diagnostic setting still present.

The isolated Purview policy remains disabled with distribution `Success`. Temporary guest access, item permissions, site collection administration, and Purview elevation had already been removed and verified. The retained app registrations have no password or certificate credentials.

[Sanitized teardown readback](docs/evidence/public/teardown-readback.json) records the public verification without tenant, subscription, principal, or resource identifiers.
