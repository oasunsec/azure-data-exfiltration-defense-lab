# Validation report

## Proven

- OAuth storage access reflected the dedicated Reader and Contributor scopes. Reader writes and Contributor role grants were rejected.
- Anonymous and shared-key data requests were rejected.
- An otherwise authorized reader was denied outside the network allowlist; restoring the rule restored access.
- The custom deny policy blocked public-blob enablement. Classification audit changed from noncompliant to compliant after remediation.
- Report-only password authentication succeeded; enforced MFA rejected the dedicated user. SigninLogs named the lab policy.
- Four telemetry tables contained lab records. The resource/time correlation returned three matched denials.
- A rejected write generated a native Medium Sentinel alert and incident 19.
- Site-level sharing rejected anonymous links for both test files.
- Historical credit-card-path behavior: after unified audit ingestion was enabled, an authenticated guest opened `Sharing_Control.txt`; `Financial_Records_CONFIDENTIAL.docx` returned a SharePoint organizational-policy access-denied page.
- Historical fresh comparison at 20:34:58 UTC reproduced that behavior: the control file opened and the financial file returned the same organizational-policy page. The redacted captures are listed in the public evidence index; this is not the authoritative isolated-policy result.
- Purview Simulation identified `Financial_Records_CONFIDENTIAL.docx` with the site-scoped `Data Defense Lab - Isolated Financial ID Validation` policy, its `Data Defense Lab - Lab Financial Record ID` rule, and the custom `Lab Financial Record ID` classifier. Distribution reached `Success` while the policy remained in simulation.
- The isolated policy then reached `Enable`/`Success`. Activity Explorer recorded `DLP rule matched` at 20:24:24 UTC and Unified Audit recorded `DLPRuleMatch` at 20:24:23 UTC. Both records named the exact financial file, isolated policy, isolated rule, custom classifier, and `BlockAccess` action. The controlled guest opened `Sharing_Control.txt` and was blocked from `Financial_Records_CONFIDENTIAL.docx`.

## Not proven

The earlier historical credit-card path still lacks an authoritative record naming **Data Defense Lab - Strict financial access restriction**, and its old rule remains `PendingDeletion` as a separate Purview cleanup issue. The separate isolated synthetic-identifier path is validated by Activity Explorer and Unified Audit, but that result does not generalize to every DLP rule or exfiltration path. A Sentinel DLP connector; endpoint DLP; USB/Bluetooth enforcement; Defender process/file/network telemetry; successful interactive MFA; exact actor attribution; prevention of every exfiltration path also remain unproven.

## Tests

**33 tests passed locally.** All four Bicep templates compiled. The [GitHub Actions validation workflow](https://github.com/oasunsec/azure-data-exfiltration-defense-lab/actions/workflows/validate.yml) runs the tests, public-file checks, Bicep compilation, and full-history Gitleaks scan on every main push. The workflow includes the DLP activation regression tests.

## Azure and identity

Storage uses Microsoft-managed keys plus infrastructure encryption, TLS 1.2, default-deny networking, disabled anonymous/shared-key access, and scoped OAuth roles. Encryption/TLS configuration is verified; cryptographic internals and protocol downgrade probes were not tested. No Owner workload role was added.

MFA is enabled only for the dedicated test user, with administrator exclusions. The test app's delegated permission is User.Read for that user. Both workload identities have zero password credentials after cleanup. The temporary Purview assignments used for this pass and the created guest were removed; user-added permissions and lab configuration are preserved.

## Purview and Defender

The isolated DLP rule targets one site, requires one high-confidence `Lab Financial Record ID` match, blocks access for all users, and has no override. Simulation matched the exact financial document at 18:24:19 UTC. After the policy reached `Enable`/`Success`, Activity Explorer recorded `DLP rule matched` at 20:24:24 UTC and Unified Audit recorded `DLPRuleMatch` at 20:24:23 UTC; both named the isolated policy, rule, classifier, file, and `BlockAccess`. The 20:30:09 UTC guest comparison opened the control file and blocked the financial file. The diagnostic policy was then disabled and reached distribution `Success`; the [final readback](docs/evidence/public/dlp-isolated-disable-readback.json) is retained with the reproducible evidence. The older credit-card path remains historical, with its strict rule `Enforce` and its retired rule `PendingDeletion` unchanged. Defender and Azure VM inventories were empty; endpoint work remains outside this release.

The earlier diagnostic pass is retained as historical context: `Test-DlpPolicies` could not evaluate the grouped strict credit-card rule, and the SharePoint page did not identify that historical rule. The isolated path avoids that ambiguity with a simple classifier condition and direct Purview records. The default policy, old strict rule, and `PendingDeletion` rule were not changed. These historical results are captured in the [sanitized diagnostic record](docs/evidence/public/dlp-policy-diagnostic.json).

The isolated validation path uses the unique `LAB-FIN-########` identifier and a simple one-classifier rule. Activity Explorer recorded the attributable simulation match at 18:24:19 UTC and the policy distributed successfully in simulation. The same policy then reached enforcement `Success`; the Activity Explorer and Unified Audit records are the authoritative match and action evidence. After the guest comparison, the policy was disabled and retained as a reproducible lab artifact.

The [read-only access diagnostic](docs/evidence/public/dlp-access-diagnostic.json) found no direct guest grant or sharing link in the current file permission responses. Group membership is not resolved by that response. The guest SharePoint sign-in at 20:30:25 UTC succeeded with Conditional Access `notApplied`; this does not identify the cause of the subsequent file denial. Fresh site/tenant readbacks showed full unmanaged-device access, no SharePoint IP allowlist enforcement, no site sensitivity label, and no Information Barriers policies or segments. The subsequent user-provided Details captures show both files as not shared, with no visible DLP warning or policy tip. The financial file displays an empty Sensitivity field; the control captures do not display that field. This post-cleanup inspection does not identify the rule behind the earlier block. File-level protection and effective group membership remain unresolved.

## Sentinel

The enabled Medium denied-write analytic produced a native alert and incident. All source rows remain in the workspace. Incident grouping is configured by storage resource; a repeated-alert grouping test remains unproven. The cross-source investigation is a resource/time join, not an identity attribution claim.

## Evidence and security

Public JSON uses selected fields and aliases. Storage, MFA, and Purview portal captures are cropped to their controls; sign-in request identifiers, URLs, record IDs, and external identities are redacted. The isolated guest result and telemetry are summarized with a sanitized external identity alias. Raw screenshots and API responses remain private. The full-history and CI secret scans passed, and the public-file privacy check found no issues. The [cleanup readback](docs/evidence/public/dlp-pass-cleanup.json) confirms zero workload passwords and removal of temporary administration.

## Recommendation

**PORTFOLIO_READY.** The isolated Purview path has attributable simulation and enforcement evidence, including `BlockAccess` telemetry and the controlled guest comparison. The historical credit-card path and its `PendingDeletion` rule remain preserved as a documented limitation. The Azure, identity, and Sentinel results stand. Defender endpoint and USB/Bluetooth work can remain outside this release.

**Public-review status: READY_FOR_PUBLIC_REVIEW.** The repository remains private per the current lab instruction.

**Lab state: RETAINED FOR CONTINUED VALIDATION.**
