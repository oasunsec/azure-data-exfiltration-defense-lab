from copy import deepcopy
import pytest
from scripts.validate_controls import evaluate_storage


@pytest.fixture
def secure():
    return {'tags': {'DataClassification': 'Confidential'}, 'properties': {
        'supportsHttpsTrafficOnly': True, 'minimumTlsVersion': 'TLS1_2',
        'allowBlobPublicAccess': False, 'allowSharedKeyAccess': False,
        'networkAcls': {'defaultAction': 'Deny', 'bypass': 'None'},
        'encryption': {'requireInfrastructureEncryption': True,
                       'services': {'blob': {'enabled': True}}},
    }}


def test_secure_baseline(secure):
    assert all(evaluate_storage(secure).values())


@pytest.mark.parametrize('field,value,control', [
    ('supportsHttpsTrafficOnly', False, 'https_required'),
    ('minimumTlsVersion', 'TLS1_0', 'minimum_tls_1_2'),
    ('allowBlobPublicAccess', True, 'anonymous_blob_disabled'),
    ('allowSharedKeyAccess', True, 'shared_key_disabled'),
    ('networkAcls', {'defaultAction': 'Allow', 'bypass': 'None'}, 'network_default_deny'),
    ('networkAcls', {'defaultAction': 'Deny', 'bypass': 'AzureServices'}, 'network_bypass_none'),
    ('encryption', {}, 'infrastructure_encryption'),
    ('encryption', {'requireInfrastructureEncryption': True}, 'blob_encryption'),
])
def test_rejects_insecure_change(secure, field, value, control):
    changed = deepcopy(secure)
    changed['properties'][field] = value
    assert evaluate_storage(changed)[control] is False


def test_missing_data_does_not_pass():
    assert not any(evaluate_storage({}).values())


def test_missing_classification(secure):
    secure['tags'] = {}
    assert not evaluate_storage(secure)['classification_tag']
