from docx import Document
from scripts.create_financial_sample import LAB_FINANCIAL_RECORD_ID, create_sample


def test_sample_is_explicitly_synthetic_and_has_no_external_relationship(tmp_path):
    path = create_sample(tmp_path)
    document = Document(path)
    text = '\n'.join(p.text for p in document.paragraphs)
    assert path.name == 'Financial_Records_CONFIDENTIAL.docx'
    assert 'All financial data used in this lab is synthetic test data.' in text
    assert LAB_FINANCIAL_RECORD_ID in text
    assert '4111 1111 1111 1111' not in text
    assert not any(rel.is_external for rel in document.part.rels.values())
