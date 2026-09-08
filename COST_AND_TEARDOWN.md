# Retained lab and cost

**Lab state: RETAINED FOR CONTINUED VALIDATION.**

The resource group, storage account, private container, policies, dedicated identities/site, diagnostic settings, and Sentinel analytic remain deployed. The existing Log Analytics/Sentinel workspace was reused. A CanNotDelete resource-group lock records the retention intent.

| Component | Cost characteristics |
| --- | --- |
| South Central US Standard LRS storage | Capacity, transactions, retained blob versions and seven-day soft-deleted data |
| Log Analytics / Sentinel | Ingestion and applicable retention/analytics charges in the existing workspace |
| Entra / Purview / Defender | Existing Microsoft 365 E5 tenant licensing; no new license purchase claimed |
| Endpoint VM | No VM deployed for this evidence set |

No measured cost saving or final billed total is claimed. Diagnostic collection includes tenant identity and subscription Activity sources, so costs are not limited to the few test rows. The workspace configuration recorded 30 days of retention; blob/container soft delete is seven days.

Temporary credentials and administrative elevation are cleanup targets; the lab resources are not. No teardown was run. Future deletion requires a separate decision, evidence export, retention review, and explicit handling of the resource lock.
