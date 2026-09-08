"""Validate a saved ARM storage response without emitting account identifiers."""
import argparse
import json
from pathlib import Path


def evaluate_storage(resource: dict) -> dict[str, bool]:
    p = resource.get('properties', {})
    network = p.get('networkAcls', {})
    encryption = p.get('encryption', {})
    return {
        'https_required': p.get('supportsHttpsTrafficOnly') is True,
        'minimum_tls_1_2': p.get('minimumTlsVersion') == 'TLS1_2',
        'anonymous_blob_disabled': p.get('allowBlobPublicAccess') is False,
        'shared_key_disabled': p.get('allowSharedKeyAccess') is False,
        'network_default_deny': network.get('defaultAction') == 'Deny',
        'network_bypass_none': network.get('bypass') == 'None',
        'infrastructure_encryption': encryption.get('requireInfrastructureEncryption') is True,
        'blob_encryption': encryption.get('services', {}).get('blob', {}).get('enabled') is True,
        'classification_tag': resource.get('tags', {}).get('DataClassification') == 'Confidential',
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('response', type=Path, help='Private JSON from az storage account show')
    args = parser.parse_args()
    resource = json.loads(args.response.read_text(encoding='utf-8-sig'))
    results = evaluate_storage(resource)
    print(json.dumps(results, indent=2))
    return 0 if all(results.values()) else 1


if __name__ == '__main__':
    raise SystemExit(main())
