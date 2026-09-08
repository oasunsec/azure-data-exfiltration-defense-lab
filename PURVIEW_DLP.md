# Purview DLP and sharing

**All financial data used in this lab is synthetic test data.**

The policy **Data Defense Lab - Financial external access** is scoped to one dedicated SharePoint site. The rule matches Credit Card Number content shared outside the organization, blocks external-user access, and disallows override. The file includes a public test card number and fictional financial values.

The site rejected anonymous-link creation for both `Financial_Records_CONFIDENTIAL.docx` and `Sharing_Control.txt` with `sharingDisabled`. No public link was created. This is evidence of the site's sharing boundary, not proof that content inspection blocked the financial file.

| Layer | Outcome |
| --- | --- |
| DLP policy/rule | Configured and exported |
| Credit-card classifier | Test-DataClassification detected one match at confidence 65, 75, and 85 in the supplied synthetic text; this was a classifier test, not a SharePoint file-enforcement result |
| Site sharing restriction | Behaviorally validated |
| Credit-card-specific external-access block | NOT VALIDATED |
| DLP alert/audit event in Sentinel | NOT VALIDATED |
| Sensitivity label enforcement | NOT VALIDATED; Confidential text is not a Purview label |

[configure_dlp.ps1](scripts/configure_dlp.ps1) uses a dedicated site parameter and defaults to simulation. The retained lab policy is enabled. Policy distribution and content processing are asynchronous; a successful configuration call is not an enforcement result.

Microsoft's [DLP rule reference](https://learn.microsoft.com/en-us/powershell/module/exchangepowershell/new-dlpcompliancerule?view=exchange-ps) defines external-user blocking and its notification requirements.
