# Tests and live checks

The automated suite checks the storage baseline validator, rejection of weakened settings, public-artifact privacy patterns, and synthetic DOCX generation without external relationships.

```sh
python -m pip install -r requirements.txt
python -m pytest -q
python scripts/check_public_files.py
```

The CI workflow also compiles every Bicep file and scans full Git history with Gitleaks. CI does not authenticate to Azure and does not rerun live changes.

Live checks used dedicated identities and synthetic documents. Actual API responses were retained privately; selected fields are published under [evidence](docs/evidence/public/README.md). These checks exercised RBAC, disabled key/anonymous access, the IP firewall, custom Azure policies, MFA rejection, and a native Sentinel detection.

The local Windows test run uses an ignored private temporary directory because the host's default pytest temporary directory denied access. This does not change the assertions. Final counts and CI outcome are in [validation](VALIDATION.md).

The Purview sharing test includes a nonsensitive control file. Both requests failed with sharingDisabled, preventing a content-specific DLP conclusion. Endpoint behavior was not simulated or counted as a passing test.
