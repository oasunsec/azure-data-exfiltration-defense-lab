"""Fail publication checks on private artifacts and common identifier exposures."""
import ipaddress
import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BLOCKED = {'evidence-private', 'generated', 'decoys', 'logs', '.venv', '__pycache__'}


def text_findings(text: str) -> list[str]:
    findings = []
    patterns = {
        'tenant domain': r'[a-z0-9-]+\.onmicrosoft\.com',
        'live Azure storage endpoint': r'https?://[a-z0-9]+\.(?:blob|table|queue|file)\.core\.windows\.net',
        'private Windows user path': r'[A-Za-z]:[\\/]Users[\\/][^\s]+',
        'Azure subscription path': r'/subscriptions/[0-9a-f]{8}-[0-9a-f-]{27,}',
        'email address': r'[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}',
    }
    for label, pattern in patterns.items():
        if re.search(pattern, text, re.IGNORECASE):
            findings.append(label)
    for candidate in re.findall(r'\b(?:\d{1,3}\.){3}\d{1,3}\b', text):
        try:
            addr = ipaddress.ip_address(candidate)
        except ValueError:
            continue
        if not addr.is_loopback and candidate not in {'0.0.0.0', '255.255.255.255'}:
            findings.append('IPv4 literal')
    return sorted(set(findings))


def main() -> int:
    paths = subprocess.check_output(['git', 'ls-files', '-z'], cwd=ROOT).decode().split('\0')
    problems = []
    for name in filter(None, paths):
        path = Path(name)
        if BLOCKED.intersection(path.parts) or path.name.startswith('.env') or path.suffix in {'.db', '.sqlite', '.log', '.docx'}:
            problems.append((name, 'private/generated artifact'))
        if path.suffix in {'.md', '.json', '.csv', '.html', '.kql'}:
            for finding in text_findings((ROOT / path).read_text(encoding='utf-8-sig')):
                problems.append((name, finding))
    for path, reason in problems:
        print(f'{path}: {reason}')
    print(f'Public file check: {len(problems)} finding(s).')
    return bool(problems)


if __name__ == '__main__':
    raise SystemExit(main())
