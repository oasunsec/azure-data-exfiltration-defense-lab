from pathlib import Path
from xml.etree import ElementTree


ROOT = Path(__file__).parents[1]


def test_isolated_rule_pack_has_one_unique_lab_classifier():
    root = ElementTree.parse(ROOT / 'scripts' / 'lab_financial_record_rulepack.xml').getroot()
    ns = {'m': 'http://schemas.microsoft.com/office/2011/mce'}
    entities = root.findall('.//m:Entity', ns)
    regexes = root.findall('.//m:Regex', ns)
    assert len(entities) == 1
    assert len(regexes) == 1
    assert entities[0].attrib['recommendedConfidence'] == '85'
    assert regexes[0].text == r'''(?:^|[\s,;:\(\)\[\]"'])(LAB-FIN-[0-9]{8})(?:$|[\s,;:\(\)\[\]"'])'''


def test_isolated_policy_script_never_mutates_historical_rules():
    script = (ROOT / 'scripts' / 'configure_isolated_dlp_validation.ps1').read_text()
    for historical_name in (
        'Data Defense Lab - Strict financial access restriction',
        'Data Defense Lab - Credit card external access block',
    ):
        assert f"Get-DlpComplianceRule -Identity '{historical_name}'" in script
        assert f"Set-DlpComplianceRule -Identity '{historical_name}'" not in script
        assert f"Remove-DlpComplianceRule -Identity '{historical_name}'" not in script
    assert "[ValidateSet('CreateSimulation','Enforce','Disable')]" in script
    assert "New-DlpCompliancePolicy -Name $policyName -SharePointLocation $LabSiteUrl.AbsoluteUri -Mode TestWithNotifications" in script
