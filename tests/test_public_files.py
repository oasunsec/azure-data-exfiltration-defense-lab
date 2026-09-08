import pytest
from scripts.check_public_files import text_findings


@pytest.mark.parametrize('sample', [
    'person@example.com',
    'example.onmicrosoft.com',
    'https://example.blob.core.windows.net',
    'C:/Users/example/private.txt',
    '/subscriptions/00000000-0000-0000-0000-000000000000',
    '192.0.2.10',
])
def test_detects_private_values(sample):
    assert text_findings(sample)


def test_allows_public_control_labels():
    assert text_findings('LAB-STORAGE-01 TLS1_2 High Medium 127.0.0.1') == []
