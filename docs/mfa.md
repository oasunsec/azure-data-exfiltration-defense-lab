# MFA test

The Conditional Access policy applies to one lab user and excludes my operator account and the Global Administrator role. A dedicated test app has delegated `User.Read` consent for that user.

| Test | Result |
| --- | --- |
| Password-only sign-in, policy in report-only mode | HTTP 200. The sign-in log shows single-factor authentication and `reportOnlyInterrupted` for the lab policy. |
| Same app and user, policy enforced | Error 50079. The log shows MFA required and Failure for the lab policy. |

The policy is still on. The [Graph template](../infra/conditional-access.example.json) starts in report-only mode and uses placeholders for the user and role IDs.

This tested rejection of a password-only sign-in. It did not test completing an MFA prompt. `CreatedDateTime` is when the sign-in happened; the workspace `TimeGenerated` is later because of ingestion delay.

[Sign-in records](evidence/public/identity-signins.json) · [policy](evidence/public/04-mfa-policy.png) · [rejected sign-in](evidence/public/05-mfa-signin-result.png) · [policy result](evidence/public/05b-mfa-policy-result.png)
