# Entra identity control

The MFA policy includes only the dedicated lab user. The existing operator and Global Administrator role are excluded. Existing policies were preserved.

| Test | Actual result |
| --- | --- |
| Dedicated sign-in app, report-only policy | Password grant returned HTTP 200. The sign-in record shows single-factor authentication and `reportOnlyInterrupted` for the lab policy. |
| Same app/user, policy enabled | Token request rejected with error 50079. The record shows MFA required, Conditional Access failure, and the lab policy's failure result. |

The test app has delegated User.Read consent for that user only. A prior Azure CLI client attempt failed with 65002 before policy evaluation; it is not counted as MFA evidence.

The recorded test is a controlled password-grant request. It does not prove completion of an interactive MFA challenge, compliant-device enforcement, phishing-resistant authentication, or location-based enforcement. The sign-in's `CreatedDateTime` is the event time; `TimeGenerated` in the workspace differs because of ingestion timing.

The [sanitized sign-in records](docs/evidence/public/identity-signins.json) retain policy outcomes while replacing the user with a lab alias. IP and device data remain private. No location or IP is treated as proof of a person's identity.
