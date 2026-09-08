# Tests and live checks

The automated suite checks the storage baseline, privacy filters, synthetic DOCX generation, and DLP activation safeguards. The DLP tests execute PowerShell against mocked cmdlets: a valid strict rule can be enabled; an override, weaker classifier, wrong site, external-only block, or invalid alert recipient fails the gate.

```sh
python -m pip install -r requirements.txt
python -m pytest -q
python scripts/check_public_files.py
```

PowerShell 7 is required for the DLP tests. GitHub Actions also compiles all four Bicep files and runs Gitleaks against full Git history. CI has no Azure credentials and does not change the lab.

I tested Azure RBAC, key/anonymous access, the IP firewall, Azure Policy, MFA, and Sentinel against the retained deployment. The [evidence index](docs/evidence/public/README.md) links the requests, responses, queries, and portal captures. [Validation](VALIDATION.md) separates these live results from the automated checks.
