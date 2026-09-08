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

**19 tests passed locally.** All four Bicep templates compiled. [GitHub Actions run 34248467181](https://github.com/oasunsec/azure-data-exfiltration-defense-lab/actions/runs/34248467181) passed tests, public-file checks, Bicep compilation, and the full-history Gitleaks scan. Automated tests validate the repository's checks and sample; they do not substitute for live enforcement evidence.

## Azure and identity

Storage uses Microsoft-managed keys plus infrastructure encryption, TLS 1.2, default-deny networking, disabled anonymous/shared-key access, and scoped OAuth roles. Encryption/TLS configuration is verified; cryptographic internals and protocol downgrade probes were not tested. No Owner workload role was added.

MFA is enabled only for the dedicated test user, with administrator exclusions. The test app's delegated permission is User.Read for that user. Both workload identities have zero password credentials after cleanup. The temporary compliance role assignment was removed; user-added permissions and lab configuration were preserved.

## Purview and Defender

The external-access DLP rule is configured on one site; the last recorded distribution state was Pending. A separate classifier test detected one credit-card match at confidence 65, 75, and 85 in synthetic text. Both sharing tests were rejected by the site's sharing restriction. Defender licensing is available, but the endpoint inventory was empty. No endpoint result is claimed.

## Sentinel

The enabled Medium denied-write analytic produced a native alert and incident. All source rows remain in the workspace. Incident grouping is configured by storage resource; a repeated-alert grouping test remains unproven. The cross-source investigation is a resource/time join, not an identity attribution claim.

## Evidence and security

Public JSON uses selected fields and aliases. Six storage and MFA portal captures are cropped to their controls; sign-in request identifiers are redacted. Raw screenshots and API responses are ignored. The initial history scan and CI scan found no secrets, and the public-file privacy check found no issues.

## Recommendation

**NEEDS_MORE_WORK** for the full data-exfiltration-defense scope. The Azure, identity, and Sentinel results stand on their own; DLP enforcement and endpoint protection remain explicit gaps.

**Lab state: RETAINED FOR CONTINUED VALIDATION.**
