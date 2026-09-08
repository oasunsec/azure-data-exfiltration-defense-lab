# Entra MFA test

I scoped the MFA Conditional Access policy to one lab user and excluded the existing operator and Global Administrator role. The dedicated test app has delegated User.Read consent for that user.

| Test | Result |
| --- | --- |
| Password grant with policy in report-only mode | HTTP 200; the sign-in log recorded single-factor authentication and `reportOnlyInterrupted` for the lab policy. |
| Same app and user with policy enabled | Error 50079; the log recorded MFA required and Failure for the lab policy. |

The retained policy is enabled. The [Graph template](infra/conditional-access.example.json) starts in report-only mode and uses placeholders for identity IDs.

[Sign-in records](docs/evidence/public/identity-signins.json) · [MFA policy](docs/evidence/public/04-mfa-policy.png) · [Rejected sign-in](docs/evidence/public/05-mfa-signin-result.png) · [Policy evaluation](docs/evidence/public/05b-mfa-policy-result.png)

This test exercised password-grant rejection, not a completed interactive MFA challenge. `CreatedDateTime` records the sign-in time; workspace `TimeGenerated` differs because of ingestion timing.
