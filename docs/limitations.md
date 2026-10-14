# Limitations

- A rejected request shows that one path was blocked. It does not show that every way out is blocked.
- Anyone with read access can still download the file. Encryption at rest does not stop an authorized download.
- An IP address can belong to a NAT gateway, VPN, proxy or security service. Matching events by resource and time does not tell you who made a request or why.
- MFA was tested by rejecting a password-only sign-in. A completed MFA prompt and device compliance were not tested.
- The first DLP test, with the built-in credit card classifier, ended on a generic block page with no record naming the rule. The custom-classifier test does have records naming the policy and rule, but it covers only this SharePoint site and was not brought into Sentinel.
- The Sentinel rule groups incidents by storage account, so requests from different callers can end up in one incident. Events that arrive more than an hour late can fall outside its lookback.
- The storage account had a public endpoint behind an IP firewall, not a private endpoint. It used Microsoft-managed keys, so customer-managed key rotation was not tested.
- Only the two custom Azure Policy definitions were tested. Other policy findings in the subscription were out of scope.

## Endpoint

Defender showed no onboarded machines and there were no lab VMs, and I kept my own workstation out of the lab. So there are no device, process, file or network events, and Endpoint DLP, USB and Bluetooth blocking, clipboard and print controls, and Defender correlation were not tested. [Inventory result](evidence/public/endpoint-readiness.json)
