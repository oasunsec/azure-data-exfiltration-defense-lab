# Azure controls

The lab resource group is in South Central US. The storage account uses Standard LRS, private blob access, seven-day blob/container soft delete, and blob versioning. Its data-plane diagnostic categories are StorageRead, StorageWrite, and StorageDelete in the dedicated `StorageBlobLogs` table.

The account key remained capable of being listed by the existing operator, but data requests signed with it were rejected. Disabling Shared Key is not equivalent to disabling the management-plane listKeys operation. No shared key is used by the lab workloads.

The custom deny policy rejected a PATCH that requested `allowBlobPublicAccess=true`. The audit policy initially detected a missing classification tag. After `DataClassification=Confidential` was applied, the custom audit and deny policies both reported compliant.

Microsoft-managed keys are retained. Customer-managed keys, private endpoints, and key rotation were not tested. Other inherited security-policy findings remain; the account is not described as universally compliant.

## Deployment artifacts

| File | Scope |
| --- | --- |
| [main.bicep](infra/main.bicep) | Storage, container, data diagnostics, retention lock |
| [policy.bicep](infra/policy.bicep) | Custom definitions and assignments to the lab RG |
| [sentinel.bicep](infra/sentinel.bicep) | Analytic in an existing workspace |

Operator IP and workspace parameters are supplied privately. The template defaults to the remediated classification tag. The temporary missing-tag state belonged to the audit experiment.

The [storage validator](scripts/validate_controls.py) evaluates a saved ARM response and emits only control booleans. It does not replace the behavioral tests.

Microsoft documents the distinction between [preventing Shared Key authorization](https://learn.microsoft.com/en-us/azure/storage/common/shared-key-authorization-prevent) and management permissions.
