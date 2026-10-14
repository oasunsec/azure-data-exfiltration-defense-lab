# Purview DLP

All document content is synthetic.

## Setup

The custom **Lab Financial Record ID** sensitive information type matches `LAB-FIN-########`. The **Data Defense Lab - Isolated Financial ID Validation** policy applies only to the lab SharePoint site. Its rule, **Data Defense Lab - Lab Financial Record ID**, needs one high-confidence match, blocks access, and does not let users override it.

`Financial_Records_CONFIDENTIAL.docx` contains `LAB-FIN-20270910`. `Sharing_Control.txt` does not.

## Result

| Step | What happened |
| --- | --- |
| Simulation | At 18:24:19 UTC the financial file matched the policy, rule and classifier. |
| Enforcement | At 20:18:48 UTC the same policy finished distributing in enforcement mode. |
| Activity Explorer | At 20:24:24 UTC, `DLP rule matched` for the financial file, with the policy, rule, classifier, confidence 85 and `BlockAccess`. |
| Unified Audit | At 20:24:23 UTC, `DLPRuleMatch` with the same file, policy, rule, classifier and `BlockAccess`. |
| Guest test | At 20:30:09 UTC an external guest opened the control file and got a block page for the financial file. |
| Cleanup | I removed the guest, the temporary permissions and the temporary admin access, then disabled the policy. |

The guest test came after the 20:24 records, and I did not find a log entry that links the two, so they are listed as separate evidence.

[Simulation](evidence/public/dlp-isolated-simulation.json) · [enforcement](evidence/public/dlp-isolated-enforcement.json) · [alert](evidence/public/dlp-isolated-alert-policy.png) · [control file](evidence/public/dlp-isolated-control.png) · [financial file blocked](evidence/public/dlp-isolated-financial-block.png)

## First attempt: built-in credit card classifier

I started with a rule called **Data Defense Lab - Strict financial access restriction** using the built-in Credit Card Number classifier. The guest was blocked from the financial file, but the block page was generic and no log record named the rule. I could not show that my rule did the blocking, so I built the custom classifier above.

That rule is still enabled on the site. An older rule, **Data Defense Lab - Credit card external access block**, is stuck in `PendingDeletion`. I did not change either one during the custom-classifier test, and neither is used as evidence for it.

This covers SharePoint only. Endpoint DLP, device transfers and Defender endpoint events were not tested. See [limitations](limitations.md).
