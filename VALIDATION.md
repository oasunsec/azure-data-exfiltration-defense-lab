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
- After unified audit ingestion was enabled, an authenticated guest opened `Sharing_Control.txt`; `Financial_Records_CONFIDENTIAL.docx` returned a SharePoint organizational-policy access-denied page.
- A fresh post-audit run at 20:34:58 UTC reproduced the comparison: the control file opened and the financial file returned the same organizational-policy page. The redacted captures are listed in the public evidence index.

## Not proven

An authoritative DLP record naming **Data Defense Lab - Strict financial access restriction** and its enforcement action. Activity Explorer completed with zero rows in the fresh window; Exchange Online `Search-UnifiedAuditLog` returned no usable result and a `BadRequest` warning; the available DLP reports returned zero rows. A Sentinel DLP connector; endpoint DLP; USB/Bluetooth enforcement; Defender process/file/network telemetry; successful interactive MFA; a combined identity-to-storage-to-DLP scenario; exact actor attribution; prevention of every exfiltration path also remain unproven.

## Tests

**30 tests passed locally.** All four Bicep templates compiled. [GitHub Actions run 34262698507](https://github.com/oasunsec/azure-data-exfiltration-defense-lab/actions/runs/34262698507) passed tests, public-file checks, Bicep compilation, and the full-history Gitleaks scan. This CI run includes the DLP activation regression tests. The latest documentation commit is checked by the same [workflow](https://github.com/oasunsec/azure-data-exfiltration-defense-lab/actions/workflows/validate.yml).

## Azure and identity

Storage uses Microsoft-managed keys plus infrastructure encryption, TLS 1.2, default-deny networking, disabled anonymous/shared-key access, and scoped OAuth roles. Encryption/TLS configuration is verified; cryptographic internals and protocol downgrade probes were not tested. No Owner workload role was added.

MFA is enabled only for the dedicated test user, with administrator exclusions. The test app's delegated permission is User.Read for that user. Both workload identities have zero password credentials after cleanup. The temporary Purview assignments used for this pass and the created guest were removed; user-added permissions and lab configuration are preserved.

## Purview and Defender

The strict DLP rule targets one site, requires a high-confidence Credit Card Number match and external sharing, blocks access except for the owner, last modifier, and site administrator, and has no override. A fresh readback reports policy distribution `Success`, the strict rule `Enforce`, and the retired rule still `PendingDeletion`. Unified audit ingestion was enabled before the controlled guest run. In the fresh run at 20:34:58 UTC, the guest opened the nonsensitive control file and received an organizational-policy block for the synthetic financial file; the page did not name a DLP rule. Activity Explorer returned zero rows, Exchange Online audit search returned no usable result with a `BadRequest` warning, and the available DLP reports returned zero rows. The [fresh behavior](docs/evidence/public/dlp-fresh-guest-test.json) and [fresh telemetry](docs/evidence/public/dlp-fresh-guest-telemetry.json) keep those results separate. Defender and Azure VM inventories were empty; endpoint work remains outside this release.

The diagnostic pass exported the current policy and rule objects and ran `Test-DlpPolicies` against both files. The financial file contained one high-confidence Credit Card Number match, but neither file was externally shared at evaluation time, so the default policy and the custom strict rule both returned `IsMatched=false` with no actions. The default policy covers all SharePoint and OneDrive locations but its rules do not block. The retired lab rule remains `PendingDeletion` and has no classifier condition in its saved `AdvancedRule`. A SharePoint UI check as the lab administrator returned `AccessDenied` for the item and library; no policy tip was available. These results are captured in the [sanitized diagnostic record](docs/evidence/public/dlp-policy-diagnostic.json). DLP enforcement remains unproven.

## Sentinel

The enabled Medium denied-write analytic produced a native alert and incident. All source rows remain in the workspace. Incident grouping is configured by storage resource; a repeated-alert grouping test remains unproven. The cross-source investigation is a resource/time join, not an identity attribution claim.

## Evidence and security

Public JSON uses selected fields and aliases. Storage, MFA, and Purview portal captures are cropped to their controls; sign-in request identifiers are redacted. The post-audit guest result and telemetry are summarized without identities, URLs, or tokens. Raw screenshots and API responses are ignored. The full-history and CI secret scans passed, and the public-file privacy check found no issues. The [cleanup readback](docs/evidence/public/dlp-pass-cleanup.json) confirms zero workload passwords and removal of temporary administration.

## Recommendation

**NEEDS_MORE_WORK.** The access restriction was observed, but content-specific Purview enforcement is not proven until authoritative telemetry names the strict rule. The Azure, identity, and Sentinel results stand. Defender endpoint and USB/Bluetooth work can remain outside this release.

**Public-review status: NOT_READY_FOR_PUBLIC.** The repository remains private.

**Lab state: RETAINED FOR CONTINUED VALIDATION.**
