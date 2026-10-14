# Investigation queries

These queries ran against the lab workspace. Public exports of their results use aliases instead of real identifiers and IP addresses.

| Query | Question | Sources |
| --- | --- | --- |
| [Storage investigation](storage-investigation.kql) | Which operation succeeded or failed, under which authentication method? | StorageBlobLogs |
| [Identity investigation](identity-investigation.kql) | Did MFA apply, and which policy rejected the request? | SigninLogs |
| [Activity investigation](activity-investigation.kql) | Which management-plane operation changed the resource? | AzureActivity |
| [Cross-source correlation](storage-change-denied-access.kql) | Did denied access follow a change on the same account within five minutes? | AzureActivity + StorageBlobLogs |
| [Denied write detection](denied-financial-write.kql) | Has a financial-record write been rejected in newly ingested events? | StorageBlobLogs |

For each denied request, the correlation query returns the closest earlier successful change to the same account. A match does not tell you who made the request or prove the change caused the denial. The firewall test is the evidence for cause and effect.

The scheduled rule checks the last five minutes of ingestion within a one-hour event lookback. Events that arrive more than an hour late are still searchable but can be missed by the rule. Incidents are grouped by storage account, so different callers on that account can end up in one incident.

There are no Defender or Purview queries here, because those sources were never connected to this workspace.
