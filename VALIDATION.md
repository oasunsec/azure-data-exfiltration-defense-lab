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

## Not proven

Content-specific SharePoint DLP enforcement; a DLP audit event or Sentinel DLP connector; endpoint DLP; USB/Bluetooth enforcement; Defender process/file/network telemetry; successful interactive MFA; a combined identity-to-storage-to-DLP scenario; exact actor attribution; prevention of every exfiltration path.

## Tests

**30 tests passed locally.** All four Bicep templates compiled. [GitHub Actions run 34262698507](https://github.com/oasunsec/azure-data-exfiltration-defense-lab/actions/runs/34262698507) passed tests, public-file checks, Bicep compilation, and the full-history Gitleaks scan. This CI run includes the DLP activation regression tests. The latest documentation commit is checked by the same [workflow](https://github.com/oasunsec/azure-data-exfiltration-defense-lab/actions/workflows/validate.yml).

## Azure and identity

Storage uses Microsoft-managed keys plus infrastructure encryption, TLS 1.2, default-deny networking, disabled anonymous/shared-key access, and scoped OAuth roles. Encryption/TLS configuration is verified; cryptographic internals and protocol downgrade probes were not tested. No Owner workload role was added.

MFA is enabled only for the dedicated test user, with administrator exclusions. The test app's delegated permission is User.Read for that user. Both workload identities have zero password credentials after cleanup. The previous temporary compliance assignment was removed. The current Purview pass has temporary Compliance Data Administrator and SharePoint Administrator assignments pending cleanup after testing; user-added permissions and lab configuration are preserved.

## Purview and Defender

The strict DLP rule targets one site, requires a high-confidence Credit Card Number match and external sharing, blocks access except for the owner, last modifier, and site administrator, and has no override. Its distribution state is recorded in the [readiness check](docs/evidence/public/dlp-strict-readiness.json). A separate classifier test detected one credit-card match at confidence 65, 75, and 85 in synthetic text. Both anonymous-link requests were rejected. A later authenticated SharePoint readback confirmed that the site already permits authenticated guest sharing; no sharing change was needed. At September 8, 18:21 UTC, policy distribution was Pending and the prior rule was PendingDeletion. The corrected alert recipient was confirmed through the API, with zero overrides. Activity Explorer returned zero records. No guest access test ran. Defender and Azure VM inventories were empty; endpoint work remains outside this release.

## Sentinel

The enabled Medium denied-write analytic produced a native alert and incident. All source rows remain in the workspace. Incident grouping is configured by storage resource; a repeated-alert grouping test remains unproven. The cross-source investigation is a resource/time join, not an identity attribution claim.

## Evidence and security

Public JSON uses selected fields and aliases. Nine storage, MFA, and Purview portal captures are cropped to their controls; sign-in request identifiers are redacted. Raw screenshots and API responses are ignored. The full-history and CI secret scans passed, and the public-file privacy check found no issues. The [cleanup readback](docs/evidence/public/dlp-pass-cleanup.json) confirms zero workload passwords and removal of the previous pass's temporary compliance role.

## Recommendation

**NEEDS_MORE_WORK.** Content-specific DLP enforcement is the remaining release requirement. The Azure, identity, and Sentinel results stand. Defender endpoint and USB/Bluetooth work can remain outside this release.

**Public-review status: NOT_READY_FOR_PUBLIC.** The repository remains private.

**Lab state: RETAINED FOR CONTINUED VALIDATION.**
