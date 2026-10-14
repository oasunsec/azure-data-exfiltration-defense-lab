# Teardown and cost

I committed the evidence first, then removed everything in Azure that costs money. Microsoft 365 objects needed to repeat the DLP test were kept. Shared resources that other projects use were left alone.

| Resource | Action | State |
| --- | --- | --- |
| Lab resource group with the storage account, `financial-records` container, blob versions and diagnostic setting | Deleted | Resource group and contents read back absent |
| Five lab role assignments | Deleted | None left at the old scope |
| `CanNotDelete` lock | Removed | Removed before the resource group was deleted |
| Two policy assignments and two policy definitions | Deleted | Definitions read back absent |
| Lab subscription Activity diagnostic setting | Deleted | The older subscription-wide setting is untouched |
| Lab Entra diagnostic setting | Deleted | |
| **Financial records - denied blob write** Sentinel analytic | Deleted | Removed after its alert and incident were captured |
| Purview policy and rule | Kept, disabled | Distribution reads back `Success` |
| **Lab Financial Record ID** classifier | Kept | Needed to repeat the DLP test |
| SharePoint lab site and two sample files | Kept | Needed to repeat the DLP test |
| Three lab app registrations | Kept | No passwords or certificates |
| Conditional Access policy and sign-in test app | Kept | Applies only to the lab user |
| Microsoft 365 unified audit | Kept on | |
| Lab user with one Microsoft 365 license | Kept, to review | License is managed outside Azure |
| Older credit card DLP rules, one in `PendingDeletion` | Kept as they were | |
| Two shared Log Analytics workspaces and an older subscription diagnostic setting | Kept | Other projects use them; their own retention and ingestion charges continue |

There was no endpoint VM to remove.

## Readback

The Azure readback at `2026-09-10T22:51:33Z` showed:

- no lab resource group, resources or role assignments
- no lab subscription or Entra diagnostic settings
- no lab Sentinel analytic
- no lab policy definitions
- the shared workspaces and the older subscription diagnostic setting still in place

The Purview policy is disabled. The temporary guest, item permissions, site admin access and Purview admin role were removed. The kept app registrations have no credentials.

[Teardown readback](evidence/public/teardown-readback.json)
