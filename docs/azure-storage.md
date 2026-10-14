# Azure storage controls

The lab ran in South Central US. The storage account was Standard LRS with private blob access, seven days of blob and container soft delete, and blob versioning. Read, write and delete logs went to the `StorageBlobLogs` table.

## Shared key

With Shared Key turned off, requests signed with the account key were rejected. The operator could still list the key, though. Turning off Shared Key blocks the key from authorizing data requests; it does not take away the management permission to read it. The lab workloads never used the key. Microsoft explains the difference in [Prevent Shared Key authorization](https://learn.microsoft.com/en-us/azure/storage/common/shared-key-authorization-prevent).

## Azure Policy

The deny policy rejected a PATCH that set `allowBlobPublicAccess=true`. The audit policy flagged the missing classification tag. After I added `DataClassification=Confidential`, both custom policies reported compliant.

Microsoft-managed keys were used. Customer-managed keys, private endpoints and key rotation were not tested. Other policy findings in the subscription were out of scope.

## Templates

| File | What it deploys |
| --- | --- |
| [main.bicep](../infra/main.bicep) | Storage account, container, diagnostics and the delete lock |
| [policy.bicep](../infra/policy.bicep) | Custom policy definitions |
| [policy-assignments.bicep](../infra/policy-assignments.bicep) | Assignments scoped to the lab resource group |
| [sentinel.bicep](../infra/sentinel.bicep) | The analytic, in an existing workspace |

The operator IP and workspace are passed in as private parameters. The template applies the classification tag by default; the missing-tag state was only for the audit test.

[validate_controls.py](../scripts/validate_controls.py) reads a saved ARM response and reports each baseline setting as pass or fail. It checks configuration only; the live tests are what show the controls work.

Everything above was deleted after the evidence was committed. See [teardown](teardown.md).
