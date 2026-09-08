# Security boundaries

Only synthetic test documents are used. Raw API responses, credentials, generated documents, screenshots awaiting review, and deployment parameters stay in ignored directories. Public evidence uses selected fields and lab aliases.

The storage endpoint is reachable only from the configured IP allowlist for data requests; the service still uses a public endpoint. Shared-key and anonymous data authorization are disabled. OAuth readers can download data when both RBAC and network controls allow it, so this configuration is not a universal exfiltration barrier.

Temporary test credentials are removed after use. No Owner assignment is required by the workload identities. Existing tenant administration is used only for provisioning; retained workloads use scoped data permissions.

The Conditional Access policy targets one lab user and excludes administrators. Site-level sharing restrictions were preserved; no external invitation or guest file permission was created during the strict-rule pass. The temporary compliance administration assignment used for Purview configuration was removed after validation. User-added permissions were preserved.

Public releases require a full-history Gitleaks scan and a separate identifier/privacy review. Secret scanning does not detect every sensitive screenshot, tenant identifier, or operational endpoint.

Report suspected exposure privately through GitHub's private vulnerability reporting if available. Do not paste credentials, signed links, or private evidence into a public issue.
