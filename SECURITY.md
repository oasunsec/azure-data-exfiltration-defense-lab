# Security

## What is in this repository

Only synthetic test documents were used. Raw API responses, credentials, generated documents, unreviewed screenshots and deployment parameters stay in ignored folders and were never committed. Public evidence keeps selected fields and uses lab aliases.

Before the repository was made public, the full history was scanned with Gitleaks and checked by hand for tenant names, IDs, emails, IPs and personal details, including every screenshot.

## How the lab was run

- Data requests were only accepted from one allowlisted IP, but the storage account still had a public endpoint. Shared-key and anonymous access were turned off. Anyone with read permission and an allowed IP could still download the file, so this setup does not stop every kind of exfiltration.
- Temporary test credentials were removed after use. The workload identities never needed Owner.
- The Conditional Access policy applied to one lab user and excluded administrators.
- The external guest, their file permissions and the temporary Purview admin role were removed after the DLP test. Existing site sharing settings and user-added permissions were not changed.

## Reporting a problem

If you find something sensitive in this repository, report it through GitHub's private vulnerability reporting. Please do not paste credentials, signed links or private evidence into a public issue.
