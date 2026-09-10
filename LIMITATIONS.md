# Limitations

- A denied operation proves that request failed; it does not prove all exfiltration paths are blocked.
- Authorized readers can retrieve the file. Storage encryption does not stop an authorized download.
- IP may represent NAT, VPN, a proxy, or security infrastructure. Resource/time correlation does not establish a person's identity or intent.
- MFA rejection was tested with a password grant. Successful interactive MFA and endpoint compliance were not tested.
- In the fresh post-audit run at 20:34:58 UTC, the authenticated guest could open the nonsensitive control file, while the financial file returned an organizational-policy access-denied page. The latest broad Unified Audit search returned 27 records, including control-file sharing and cleanup, but no strict-rule enforcement record. Activity Explorer returned only a default-policy DLP rule undo. The three DLP report cmdlets returned service-unavailable errors; those failures do not establish that records are absent. The page and queries did not identify the enforcing Purview rule, so a content-specific DLP block, corresponding audit event, and Sentinel DLP ingestion remain unproven.
- No Defender endpoint was onboarded. Endpoint DLP, USB and Bluetooth controls, clipboard/print restrictions, and endpoint correlation were not tested.
- The Sentinel analytic groups by storage resource and can combine different callers. Native grouping is not exact request deduplication. Events delayed more than an hour can miss its scheduled lookback.
- The account has a public endpoint with an IP firewall, not a private endpoint. Microsoft-managed keys are used; customer-managed key lifecycle was not tested.
- Other inherited Azure Policy findings remain outside the two custom-policy tests. The project does not claim complete tenant compliance.
- Document external content can be blocked, offline opens may not fire, and scanners can trigger callbacks. A callback proves neither exfiltration nor who opened a file.

These controls complement DLP, access controls, encryption, EDR, file auditing, and SIEM monitoring. Stronger attribution requires those sources to be correlated using actual events.
