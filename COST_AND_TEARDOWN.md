# Cost and teardown

Evidence was committed before the dedicated Azure infrastructure was removed. Microsoft 365 artifacts required to reproduce the DLP scenario were retained, and shared pre-existing resources were left unchanged.

`DELETE_BILLABLE` marks removed lab infrastructure. `KEEP_FREE` marks retained objects without a separate metered Azure resource in the observed state. `REVIEW` marks shared or licensed tenant objects managed outside the Azure teardown.

## Inventory

| Resource or object | Classification | Disposition |
| --- | --- | --- |
| Dedicated Azure resource group, Standard LRS storage account, private `financial-records` container, blob versions, soft-delete state, and blob diagnostic setting | `DELETE_BILLABLE` | Deleted; the resource group and contained resources read back absent. |
| Five lab-scoped Azure role assignments | `DELETE_BILLABLE` | Deleted; no assignment remains at the removed scope. |
| Resource-group `CanNotDelete` lock | `DELETE_BILLABLE` | Removed before resource-group deletion. |
| Two resource-group Azure Policy assignments and two lab-only policy definitions | `DELETE_BILLABLE` | Deleted; definitions read back absent. |
| Lab subscription Activity diagnostic setting | `DELETE_BILLABLE` | Deleted. The pre-existing subscription diagnostic setting remains. |
| Lab Entra identity diagnostic setting | `DELETE_BILLABLE` | Deleted. |
| **Financial records - denied blob write** Sentinel analytic | `DELETE_BILLABLE` | Deleted after its alert and incident evidence was captured. |
| Isolated Purview policy and rule | `KEEP_FREE` | Retained disabled; distribution readback is `Success`. |
| **Lab Financial Record ID** sensitive information type | `KEEP_FREE` | Retained as the synthetic classifier. |
| SharePoint lab site and two synthetic samples | `KEEP_FREE` | Retained for reproduction. |
| Three lab app registrations and service principals | `KEEP_FREE` | Retained with zero password and key credentials. |
| Scoped Conditional Access policy and sign-in test application | `KEEP_FREE` | Retained for the dedicated lab user. |
| Microsoft 365 unified audit ingestion | `KEEP_FREE` | Retained enabled. |
| Dedicated lab user with one Microsoft 365 license | `REVIEW` | Retained; license management is separate from Azure teardown. |
| Historical strict Purview rule and stale `PendingDeletion` rule | `REVIEW` | Retained unchanged. |
| Shared `canarysec-law` and `law-sc500-day06` workspaces | `REVIEW` | Retained because other projects use them. Existing retention and ingestion charges still apply. |
| Pre-existing `diag-subscription-to-law` diagnostic setting | `REVIEW` | Retained unchanged. |

No endpoint VM existed in the inventory.

## Readback

The Azure readback at `2026-09-10T22:51:33Z` found:

- no dedicated resource group, contained resources, or lab-scoped role assignments;
- no lab subscription or Entra diagnostic settings;
- no lab Sentinel analytic;
- no lab Azure Policy definitions;
- both shared workspace resource groups and the pre-existing subscription diagnostic setting still present.

The isolated Purview policy is disabled with distribution `Success`. Temporary guest access, item permissions, site administration, and Purview elevation were removed. Retained app registrations have no password or certificate credentials.

[Sanitized teardown readback](docs/evidence/public/teardown-readback.json)
