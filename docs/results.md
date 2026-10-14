# Results

## Azure and identity

- The Reader identity could download the file but not overwrite it. The Contributor identity could upload but could not grant roles.
- Anonymous requests and requests signed with the account key were both rejected.
- The Reader was denied once its IP was removed from the allowlist, and got access back when the IP was restored.
- Azure Policy rejected turning on public blob access. The classification tag audit showed noncompliant until the tag was added, then compliant.
- With the Conditional Access policy enforced, the lab user's password-only sign-in was rejected, and the failure showed up in `SigninLogs`.
- `StorageBlobLogs`, `AzureActivity`, `SigninLogs` and `AuditLogs` all received lab events.
- A rejected write raised a native Medium Sentinel alert and incident.
- The SharePoint site refused to create anonymous links for either test file.

## Purview DLP, step by step

1. **18:24:19 UTC.** In simulation, the custom `Lab Financial Record ID` classifier matched `Financial_Records_CONFIDENTIAL.docx`.
2. **20:18:48 UTC.** The site-scoped **Data Defense Lab - Isolated Financial ID Validation** policy finished distributing in enforcement mode.
3. **20:24 UTC.** Activity Explorer logged `DLP rule matched` and Unified Audit logged `DLPRuleMatch`. Both name the file, the policy, the rule, the classifier and `BlockAccess`.
4. **20:30:09 UTC.** An external guest opened `Sharing_Control.txt` and was blocked from the financial document.
5. I removed the guest, the temporary permissions and the temporary admin access, then disabled the policy.

The 20:24 records and the 20:30 guest test are two separate pieces of evidence. I did not find a log entry that ties the guest's blocked request to the 20:24 match.

The earlier test with the built-in credit card classifier never produced a record naming its rule, so I only keep it as a record of what did not work. Its old rule is still in `PendingDeletion` and I left it alone.

## Not tested

- Endpoint DLP, USB and Bluetooth blocking, clipboard and print controls, and Defender endpoint correlation. No endpoint was onboarded.
- Completing an interactive MFA prompt. Only the password-only rejection was tested.
- Purview events in Sentinel. They were never ingested.

The investigation query matches events by resource and time. It does not identify who made a request or why.

## Automated checks

33 tests passed locally and all four Bicep templates compiled. [GitHub Actions](https://github.com/oasunsec/azure-data-exfiltration-defense-lab/actions/workflows/validate.yml) runs the tests, the public-file check, the Bicep build and a full-history Gitleaks scan. The run is recorded in [release-checks.json](evidence/public/release-checks.json).

## Evidence handling

Public JSON keeps only the fields that matter and uses lab aliases. Screenshots have request IDs, URLs, record IDs, tenant details and guest identities blacked out. Raw captures and API responses were never committed.
