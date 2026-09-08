from pathlib import Path
import subprocess,shutil
import pytest

PWSH=shutil.which('pwsh')
ROOT=Path(__file__).resolve().parents[1]

@pytest.mark.skipif(not PWSH,reason='PowerShell 7 required for mocked DLP deployment tests')
@pytest.mark.parametrize('scenario,expected', [('strict','ENABLED'),('override','REJECTED'),('weak_classifier','REJECTED'),('wrong_site','REJECTED'),('external_only','REJECTED'),('invalid_stored_alert','REJECTED'),('invalid_supplied_alert','REJECTED'),('advanced','ENABLED'),('advanced_or','REJECTED'),('advanced_weak','REJECTED'),('advanced_extra','REJECTED')])
def test_dlp_activation_gate(tmp_path,scenario,expected):
    harness=r'''
param($Scenario,$Script)
$ErrorActionPreference='Stop'
$global:activated=$false
function Get-DlpCompliancePolicy { [pscustomobject]@{Name='Data Defense Lab - Financial external access';Mode=$(if($global:activated){'Enable'}else{'TestWithoutNotifications'});SharePointLocation=@([pscustomobject]@{Name=$(if($Scenario -eq 'wrong_site'){'https://example.invalid/sites/other'}else{'https://example.invalid/sites/lab'})})} }
function Get-DlpComplianceRule { $result=[pscustomobject]@{Name='Data Defense Lab - Strict financial access restriction';GenerateAlert=$(if($Scenario -eq 'invalid_stored_alert'){'True'}else{'lab-admin@example.invalid'});BlockAccess=$true;Disabled=$false;BlockAccessScope=$(if($Scenario -eq 'external_only'){'PerUser'}else{'All'});AccessScope='NotInOrganization';NotifyAllowOverride=$(if($Scenario -eq 'override'){'FalsePositive'}else{$null});ContentContainsSensitiveInformation=@(@{name='Credit Card Number';mincount=1;minconfidence=$(if($Scenario -eq 'weak_classifier'){65}else{85})})}
if ($Scenario -like 'advanced*') {
 $result.AccessScope=$null; $result.ContentContainsSensitiveInformation=$null
 $predicates=@(@{ConditionName='AccessScope';Value='NotInOrganization'},@{ConditionName='ContentContainsSensitiveInformation';Value=@(@{Operator='And';Groups=@(@{Operator='Or';Sensitivetypes=@(@{Name='Credit Card Number';Mincount=1;Minconfidence=$(if($Scenario -eq 'advanced_weak'){65}else{85})})})})})
 if($Scenario -eq 'advanced_extra'){$predicates+=@{ConditionName='AccessScope';Value='InOrganization'}}
 $json=@{Version='1.0';Condition=@{Operator=$(if($Scenario -eq 'advanced_or'){'Or'}else{'And'});SubConditions=$predicates}} | ConvertTo-Json -Depth 12
 $result | Add-Member AdvancedRule $json
}
$result
}
function Set-DlpCompliancePolicy { $global:activated=$true }
try { & $Script -LabSiteUrl 'https://example.invalid/sites/lab' -AlertRecipient $(if($Scenario -eq 'invalid_supplied_alert'){'True'}else{'lab-admin@example.invalid'}) -Mode Enable | Out-Null; if(-not $global:activated){throw 'No activation'}; 'ENABLED' } catch { if($global:activated){throw 'Policy activated before rejection'}; 'REJECTED' }
'''
    path=tmp_path/'harness.ps1';path.write_text(harness)
    result=subprocess.run([PWSH,'-NoProfile','-File',str(path),scenario,str(ROOT/'scripts/configure_dlp.ps1')],capture_output=True,text=True,timeout=30)
    assert result.returncode==0,result.stderr
    assert result.stdout.strip()==expected,result.stdout+result.stderr
