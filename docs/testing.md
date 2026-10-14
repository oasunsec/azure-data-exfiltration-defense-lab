# Testing

## Automated tests

The test suite covers the storage baseline check, the privacy filter, the synthetic DOCX generator and the safety checks in the DLP setup script.

The DLP tests run the PowerShell setup against mocked cmdlets. A correct strict rule can be turned on. A rule with a user override, a weaker classifier, the wrong site, an external-only block or a bad alert recipient is refused. The same checks accept the equivalent rule exported from the portal, and refuse one with an OR, an extra condition or a weaker classifier.

```sh
python -m pip install -r requirements.txt
python -m pytest -q
python scripts/check_public_files.py
```

The DLP tests need PowerShell 7. Pytest only collects `tests/` and writes its output to the ignored `runtime/test-output/` folder.

GitHub Actions also builds all four Bicep files and runs Gitleaks over the full history. It has no Azure credentials and does not change anything in the lab.

## Live tests

RBAC, key and anonymous access, the IP firewall, Azure Policy, MFA and the Sentinel detection were all tested against the real lab. The [evidence index](evidence/public/README.md) links the requests, responses, queries and screenshots, and [results](results.md) lists what happened.
