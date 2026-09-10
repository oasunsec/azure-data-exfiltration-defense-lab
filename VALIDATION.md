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
- Purview Simulation identified `Financial_Records_CONFIDENTIAL.docx` with the site-scoped `Data Defense Lab - Isolated Financial ID Validation` policy, its `Data Defense Lab - Lab Financial Record ID` rule, and the custom `Lab Financial Record ID` classifier. Distribution reached `Success` while the policy remained in simulation.
- The isolated policy then reached enforcement distribution `Success`. Activity Explorer recorded `DLP rule matched` at 20:24:24 UTC and Unified Audit recorded `DLPRuleMatch` at 20:24:23 UTC. Both records named the exact financial file, isolated policy, isolated rule, custom classifier, and `BlockAccess` action.
- A subsequent guest comparison at 20:30:09 UTC opened `Sharing_Control.txt` and blocked `Financial_Records_CONFIDENTIAL.docx`. Direct event correlation to the earlier 20:24 telemetry was not established or claimed.

## Not proven

The earlier historical credit-card path still lacks an authoritative record naming **Data Defense Lab - Strict financial access restriction**, and its old rule remains `PendingDeletion` as a separate Purview cleanup issue. The separate isolated synthetic-identifier path is validated by Activity Explorer and Unified Audit, but that result does not generalize to every DLP rule or exfiltration path. A Sentinel DLP connector; endpoint DLP; USB/Bluetooth enforcement; Defender process/file/network telemetry; successful interactive MFA; exact actor attribution; prevention of every exfiltration path also remain unproven.

## Tests

**33 tests passed locally.** All four Bicep templates compiled. The [GitHub Actions validation workflow](https://github.com/oasunsec/azure-data-exfiltration-defense-lab/actions/workflows/validate.yml) runs the tests, public-file checks, Bicep compilation, and full-history Gitleaks scan on every main push. The workflow includes the DLP activation regression tests. Final release checks are recorded in [release-checks.json](docs/evidence/public/release-checks.json).

## Azure and identity

Storage uses Microsoft-managed keys plus infrastructure encryption, TLS 1.2, default-deny networking, disabled anonymous/shared-key access, and scoped OAuth roles. Encryption/TLS configuration is verified; cryptographic internals and protocol downgrade probes were not tested. No Owner workload role was added.

MFA is enabled only for the dedicated test user, with administrator exclusions. The test app's delegated permission is User.Read for that user. Both workload identities have zero password credentials after cleanup. The temporary Purview assignments used for this pass and the created guest were removed; user-added permissions and lab configuration are preserved.

## Purview and Defender

The isolated DLP rule targets one site, requires one high-confidence `Lab Financial Record ID` match, blocks access for all users, and has no override. Simulation matched the exact financial document at 18:24:19 UTC. After enforcement distribution reached `Success`, Activity Explorer and Unified Audit independently named the isolated policy, rule, classifier, file, and `BlockAccess` at 20:24 UTC. The 20:30:09 UTC guest comparison later opened the control file and blocked the financial file; it is supporting behavioral validation, not a directly correlated audit event. The diagnostic policy was then disabled and reached distribution `Success`; the [final readback](docs/evidence/public/dlp-isolated-disable-readback.json) is retained with the reproducible evidence.

The older credit-card path remains private troubleshooting history. Its strict rule remains `Enforce`, and its retired rule remains `PendingDeletion` as a separate cleanup issue. Neither historical object was changed. Defender and Azure VM inventories were empty; endpoint work remains outside this release.

## Sentinel

The Medium denied-write analytic produced a native alert and incident before teardown. Its evidence remains committed; the dedicated analytic was then deleted from the shared workspace. Previously ingested rows remain subject to that workspace's retention. Incident grouping was configured by storage resource, but a repeated-alert grouping test remains unproven. The cross-source investigation is a resource/time join, not an identity attribution claim.

## Evidence and security

Public JSON uses selected fields and aliases. Storage, MFA, and Purview portal captures are cropped to their controls; sign-in request identifiers, URLs, record IDs, and external identities are redacted. The isolated guest result and telemetry are summarized with a sanitized external identity alias. Raw screenshots and API responses remain private. The full-history and CI secret scans passed, and the public-file privacy check found no issues. The [cleanup readback](docs/evidence/public/dlp-pass-cleanup.json) confirms zero workload passwords and removal of temporary administration.

## Recommendation

**PORTFOLIO_READY.** The isolated Purview path has attributable simulation and enforcement evidence, including `BlockAccess` telemetry and the controlled guest comparison. The historical credit-card path and its `PendingDeletion` rule remain preserved as a documented limitation. The Azure, identity, and Sentinel results stand. Defender endpoint and USB/Bluetooth work can remain outside this release.

**Public-review status: READY_TO_PUBLISH.** The repository remains private so the owner can perform the final visibility change.

**Lab state: AZURE TEARDOWN COMPLETE; MICROSOFT 365 EVIDENCE ARTIFACTS RETAINED.** The dedicated Azure resource group, lab diagnostics, Azure Policy objects, scoped role assignments, and Sentinel analytic were removed after proof was committed. The isolated Purview policy remains disabled, and the historical `PendingDeletion` object remains untouched. See [cost and teardown](COST_AND_TEARDOWN.md).
