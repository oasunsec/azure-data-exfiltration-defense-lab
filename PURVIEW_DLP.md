# Purview DLP

All document content is synthetic.

## Isolated policy

The custom **Lab Financial Record ID** sensitive information type recognizes `LAB-FIN-########`. The **Data Defense Lab - Isolated Financial ID Validation** policy is scoped to the dedicated SharePoint site. Its **Data Defense Lab - Lab Financial Record ID** rule requires one high-confidence match, applies `BlockAccess`, and has no user override.

`Financial_Records_CONFIDENTIAL.docx` contains `LAB-FIN-20270910`. `Sharing_Control.txt` does not.

| Evidence | Observed result |
| --- | --- |
| Simulation | The financial file matched the isolated policy, rule, and classifier at 18:24:19 UTC; distribution reached `Success`. |
| Enforcement distribution | The same policy reached `Enable`/`Success` at 20:18:48 UTC. |
| Activity Explorer | `DLP rule matched` at 20:24:24 UTC with the financial file, policy, rule, classifier, confidence 85, and `BlockAccess`. |
| Unified Audit | `DLPRuleMatch` at 20:24:23 UTC with the same file, policy, rule, classifier, and `BlockAccess`. |
| Guest comparison | At 20:30:09 UTC, the control file opened and the financial file returned an organizational-policy block page. |
| Cleanup | The guest, temporary permissions, and temporary administration were removed. The policy was disabled with distribution `Success`. |

[Simulation evidence](docs/evidence/public/dlp-isolated-simulation.json) · [Enforcement evidence](docs/evidence/public/dlp-isolated-enforcement.json) · [Alert capture](docs/evidence/public/dlp-isolated-alert-policy.png) · [Control result](docs/evidence/public/dlp-isolated-control.png) · [Financial block](docs/evidence/public/dlp-isolated-financial-block.png)

The guest comparison occurred after the Purview telemetry. The records are presented separately because no direct event correlation was established.

## Historical policy

The earlier **Data Defense Lab - Strict financial access restriction** rule remains enabled and site-scoped. The retired **Data Defense Lab - Credit card external access block** rule remains `PendingDeletion`. Neither rule was changed during the isolated-policy test, and neither supports the isolated-policy result.

The evidence establishes the tested SharePoint classifier and `BlockAccess` behavior. Endpoint DLP, device-transfer controls, Defender endpoint telemetry, and universal exfiltration prevention are outside this result. See [limitations](LIMITATIONS.md).
