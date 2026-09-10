# Limitations

- A denied operation proves that request failed; it does not prove all exfiltration paths are blocked.
- Authorized readers can retrieve the file. Storage encryption does not stop an authorized download.
- IP may represent NAT, VPN, a proxy, or security infrastructure. Resource/time correlation does not establish a person's identity or intent.
- MFA rejection was tested with a password grant. Successful interactive MFA and endpoint compliance were not tested.
- The earlier credit-card-path guest run returned a generic organizational-policy page and did not identify its historical strict rule. That path remains a limitation record. The separate isolated synthetic-identifier path matched in Simulation and Enforce: Activity Explorer and Unified Audit named the isolated policy, rule, classifier, and `BlockAccess`, and the control file opened while the financial file was blocked. The guest-facing page remains generic, so attribution comes from Purview telemetry. This proves the isolated SharePoint scenario only; it does not prove every exfiltration path or Sentinel DLP ingestion.
- No Defender endpoint was onboarded. Endpoint DLP, USB and Bluetooth controls, clipboard/print restrictions, and endpoint correlation were not tested.
- The Sentinel analytic groups by storage resource and can combine different callers. Native grouping is not exact request deduplication. Events delayed more than an hour can miss its scheduled lookback.
- The account has a public endpoint with an IP firewall, not a private endpoint. Microsoft-managed keys are used; customer-managed key lifecycle was not tested.
- Other inherited Azure Policy findings remain outside the two custom-policy tests. The project does not claim complete tenant compliance.
- Document external content can be blocked, offline opens may not fire, and scanners can trigger callbacks. A callback proves neither exfiltration nor who opened a file.

These controls complement DLP, access controls, encryption, EDR, file auditing, and SIEM monitoring. Stronger attribution requires those sources to be correlated using actual events.
