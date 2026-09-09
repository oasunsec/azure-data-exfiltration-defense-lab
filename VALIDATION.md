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

## Not proven

An authoritative DLP record naming **Data Defense Lab - Strict financial access restriction**; a Sentinel DLP connector; endpoint DLP; USB/Bluetooth enforcement; Defender process/file/network telemetry; successful interactive MFA; a combined identity-to-storage-to-DLP scenario; exact actor attribution; prevention of every exfiltration path.

## Tests

**30 tests passed locally.** All four Bicep templates compiled. [GitHub Actions run 34262698507](https://github.com/oasunsec/azure-data-exfiltration-defense-lab/actions/runs/34262698507) passed tests, public-file checks, Bicep compilation, and the full-history Gitleaks scan. This CI run includes the DLP activation regression tests. The latest documentation commit is checked by the same [workflow](https://github.com/oasunsec/azure-data-exfiltration-defense-lab/actions/workflows/validate.yml).

## Azure and identity

Storage uses Microsoft-managed keys plus infrastructure encryption, TLS 1.2, default-deny networking, disabled anonymous/shared-key access, and scoped OAuth roles. Encryption/TLS configuration is verified; cryptographic internals and protocol downgrade probes were not tested. No Owner workload role was added.

MFA is enabled only for the dedicated test user, with administrator exclusions. The test app's delegated permission is User.Read for that user. Both workload identities have zero password credentials after cleanup. The temporary Purview assignments used for this pass and the created guest were removed; user-added permissions and lab configuration are preserved.

## Purview and Defender

The strict DLP rule targets one site, requires a high-confidence Credit Card Number match and external sharing, blocks access except for the owner, last modifier, and site administrator, and has no override. A fresh readback reports policy distribution `Success`, the strict rule `Enforce`, and the retired rule still `PendingDeletion`. Unified audit ingestion was enabled before the controlled guest run. The guest opened the nonsensitive control file and received an organizational-policy block for the synthetic financial file; the page did not name a DLP rule. Activity Explorer and the available DLP reports returned no authoritative record during the observation window. The [post-audit behavior](docs/evidence/public/dlp-post-audit-test.json) and [telemetry result](docs/evidence/public/dlp-post-audit-telemetry.json) keep those results separate. Defender and Azure VM inventories were empty; endpoint work remains outside this release.

## Sentinel

The enabled Medium denied-write analytic produced a native alert and incident. All source rows remain in the workspace. Incident grouping is configured by storage resource; a repeated-alert grouping test remains unproven. The cross-source investigation is a resource/time join, not an identity attribution claim.

## Evidence and security

Public JSON uses selected fields and aliases. Storage, MFA, and Purview portal captures are cropped to their controls; sign-in request identifiers are redacted. The post-audit guest result and telemetry are summarized without identities, URLs, or tokens. Raw screenshots and API responses are ignored. The full-history and CI secret scans passed, and the public-file privacy check found no issues. The [cleanup readback](docs/evidence/public/dlp-pass-cleanup.json) confirms zero workload passwords and removal of temporary administration.

## Recommendation

**NEEDS_MORE_WORK.** The access restriction was observed, but content-specific Purview enforcement is not proven until authoritative telemetry names the strict rule. The Azure, identity, and Sentinel results stand. Defender endpoint and USB/Bluetooth work can remain outside this release.

**Public-review status: NOT_READY_FOR_PUBLIC.** The repository remains private.

**Lab state: RETAINED FOR CONTINUED VALIDATION.**
