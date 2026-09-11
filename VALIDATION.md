# Test results

## Observed controls

- OAuth storage access reflected the dedicated Reader and Contributor scopes. Reader writes and Contributor role grants were rejected.
- Anonymous and shared-key data requests were rejected.
- An authorized reader was denied outside the network allowlist and regained access after the rule was restored.
- Azure Policy blocked public-blob enablement and reported the classification tag compliant after remediation.
- The enforced Conditional Access policy rejected the dedicated user's password-only sign-in and appeared in `SigninLogs`.
- `StorageBlobLogs`, `AzureActivity`, `SigninLogs`, and `AuditLogs` contained lab events.
- A rejected write generated a native Medium Sentinel alert and incident.
- The SharePoint site rejected anonymous links for both test files.

## Purview DLP sequence

1. The custom `Lab Financial Record ID` classifier matched `Financial_Records_CONFIDENTIAL.docx` in simulation at 18:24:19 UTC.
2. The site-scoped **Data Defense Lab - Isolated Financial ID Validation** policy reached enforcement distribution `Success` at 20:18:48 UTC.
3. Activity Explorer recorded `DLP rule matched` at 20:24:24 UTC. Unified Audit recorded `DLPRuleMatch` at 20:24:23 UTC. Both named the financial file, isolated policy, isolated rule, custom classifier, and `BlockAccess`.
4. A guest comparison at 20:30:09 UTC opened `Sharing_Control.txt` and blocked the financial document.
5. The guest, temporary item permissions, and temporary administrative access were removed. The diagnostic policy was disabled and reached distribution `Success`.

The 20:24 telemetry and 20:30 guest requests are separate evidence sets; no direct event correlation is asserted. The earlier credit-card scenario did not produce an authoritative record naming its strict rule, so it is retained only as historical troubleshooting evidence. Its stale rule remains `PendingDeletion` and was not modified.

## Scope boundaries

- Endpoint DLP, USB/Bluetooth controls, clipboard and print restrictions, and Defender endpoint correlation were not tested because no lab endpoint was onboarded.
- Successful interactive MFA was not tested; the identity test covered password-only rejection.
- The resource/time KQL join does not identify a person or intent.
- Sentinel did not ingest or correlate the Purview event.
- The results apply to the tested controls and do not claim prevention of every exfiltration path.

## Automated checks

The local suite passed 33 tests, and all four Bicep templates compiled. [GitHub Actions](https://github.com/oasunsec/azure-data-exfiltration-defense-lab/actions/workflows/validate.yml) runs the tests, public-file checks, Bicep compilation, and a full-history Gitleaks scan. Results are recorded in [release-checks.json](docs/evidence/public/release-checks.json).

## Evidence handling and teardown

Public JSON contains selected fields and aliases. Portal captures redact request identifiers, URLs, record IDs, tenant details, and external identities. Raw captures and API responses stay outside Git tracking.

The dedicated Azure resource group, lab diagnostics, Azure Policy objects, scoped role assignments, and Sentinel analytic were removed. The isolated Purview policy remains disabled, the SharePoint samples remain available, and the historical `PendingDeletion` object remains unchanged. See [cost and teardown](COST_AND_TEARDOWN.md).
