# Purview DLP validation

**Sample uses synthetic financial data only.**

## Isolated simulation-to-enforcement path

The reproducible lab path uses the custom **Lab Financial Record ID** sensitive information type for the synthetic `LAB-FIN-########` identifier. **Data Defense Lab - Isolated Financial ID Validation** is scoped only to the dedicated SharePoint lab site. Its rule, **Data Defense Lab - Lab Financial Record ID**, has one content condition, requires one high-confidence match, blocks access for all users, and has no user override. `Financial_Records_CONFIDENTIAL.docx` contains `LAB-FIN-20270910`; `Sharing_Control.txt` does not.

Purview Simulation first matched the financial document on 2026-09-10 at 18:24:19 UTC. Activity Explorer named the isolated policy, rule, and classifier, with one match at confidence 85. The policy reached distribution `Success` while still in simulation, then reached enforcement distribution `Success` at 20:18:48 UTC.

Activity Explorer recorded `DLP rule matched` at 20:24:24 UTC for the exact financial file and named the isolated policy, rule, classifier, and `BlockAccess`. Unified Audit recorded `DLPRuleMatch` at 20:24:23 UTC with the same policy, rule, classifier, file, and action. The [isolated enforcement record](docs/evidence/public/dlp-isolated-enforcement.json) and sanitized [alert-policy capture](docs/evidence/public/dlp-isolated-alert-policy.png) preserve those fields.

The guest comparison occurred later, at 20:30:09 UTC. `Sharing_Control.txt` opened, while `Financial_Records_CONFIDENTIAL.docx` returned the generic SharePoint message, “Due to organizational policies, you can't access this resource.” This is subsequent behavioral validation. The evidence does not directly correlate the 20:24 telemetry records to the later guest requests, and the guest page itself does not name a DLP rule.

The guest directory object and the two item permissions created for this pass were removed after the comparison. Original site groups and tenant/site sharing settings were preserved. The diagnostic policy is disabled and retained as a reproducible lab artifact; the final public [disable readback](docs/evidence/public/dlp-isolated-disable-readback.json) records `Disable` with distribution `Success`.

## Isolated test results

| Test | Observed result | Evidence |
| --- | --- | --- |
| Simulation gate | Exact financial file matched the isolated policy, rule, and `Lab Financial Record ID`; distribution `Success` | [Simulation evidence](docs/evidence/public/dlp-isolated-simulation.json), [simulation detail](docs/evidence/public/dlp-isolated-simulation-detail.png) |
| Enforcement readback | Policy reached `Enable`/`Success`; rule used `BlockAccess` with no overrides | [Enforcement evidence](docs/evidence/public/dlp-isolated-enforcement.json), [enforcement detail](docs/evidence/public/dlp-isolated-enforcement-detail.png) |
| Activity Explorer | `DLP rule matched`; exact file, policy, rule, classifier, confidence 85, and `BlockAccess` | [Enforcement evidence](docs/evidence/public/dlp-isolated-enforcement.json) |
| Unified Audit | `DLPRuleMatch`; exact file, policy, rule, classifier, `BlockAccess`, and sanitized external identity alias | [Enforcement evidence](docs/evidence/public/dlp-isolated-enforcement.json) |
| Subsequent guest comparison | Control file opened; financial file was blocked; no direct correlation to the earlier telemetry is asserted | [Guest control](docs/evidence/public/dlp-isolated-control.png), [financial block](docs/evidence/public/dlp-isolated-financial-block.png) |
| Alert details | Purview alert named the isolated policy and rule and recorded the matching financial document | [Alert capture](docs/evidence/public/dlp-isolated-alert-policy.png) |
| Cleanup | Guest and this pass's item permissions removed; original sharing settings preserved | Private cleanup readbacks under `evidence-private/isolated-dlp-validation/` |

## Historical credit-card path

The earlier **Data Defense Lab - Financial external access** path remains historical evidence. Its strict rule, **Data Defense Lab - Strict financial access restriction**, is still `Enforce`, priority 0, and site-scoped. The old **Data Defense Lab - Credit card external access block** remains `PendingDeletion`; this is a separate Purview cleanup issue, and it was left untouched. Neither historical rule was modified or deleted during the isolated validation. The earlier generic access-denied page and ambiguous telemetry are retained as a limitation record; they are not used to claim enforcement of the historical rule.

## Boundaries

The result proves the isolated synthetic classifier and `BlockAccess` action for this SharePoint test. It does not prove that every exfiltration path is closed, identify a person or intent, or validate endpoint DLP, USB/Bluetooth controls, or Defender process/file/network telemetry. The guest-facing page is generic; the rule attribution comes from Purview Activity Explorer and Unified Audit.

See the [validation report](VALIDATION.md), [control matrix](CONTROL_MATRIX.md), [public evidence index](docs/evidence/public/README.md), and [limitations](LIMITATIONS.md).
