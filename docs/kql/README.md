# Investigation queries

These queries ran against the retained lab workspace. Identifiers and IP addresses belong in the private investigation record; public exports use aliases.

| Query | Question | Sources |
| --- | --- | --- |
| [Storage investigation](storage-investigation.kql) | Which operation succeeded or failed, under which authentication method? | StorageBlobLogs |
| [Identity investigation](identity-investigation.kql) | Did MFA apply, and which policy rejected the request? | SigninLogs |
| [Activity investigation](activity-investigation.kql) | Which management-plane operation changed the resource? | AzureActivity |
| [Cross-source correlation](storage-change-denied-access.kql) | Did denied access follow a change on the same account within five minutes? | AzureActivity + StorageBlobLogs |
| [Denied write detection](denied-financial-write.kql) | Has a financial-record write been rejected in newly ingested events? | StorageBlobLogs |

The correlation query returns the closest preceding successful account write for each denied request. A match does not identify the actor or prove that the change caused the denial. The controlled firewall test supplies the separate causal evidence.

The scheduled rule checks five minutes of ingestion time within a one-hour event lookback. Events delayed beyond one hour remain searchable but can fall outside this detection. Incident grouping uses the storage resource; it can combine different callers on that account. It is not exact per-request deduplication.

Defender and Purview event queries are not presented as working integrations because those sources have not been validated in this workspace.
