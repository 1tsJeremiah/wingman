from pathlib import Path

# Allow this test to run from any directory by computing the repository
# root relative to this file.
REPO_ROOT = Path(__file__).resolve().parents[2]
SCRIPT_PATH = REPO_ROOT / 'devops' / 'scripts' / 'executable_deploy-landscape-script.sh'


def test_deploy_landscape_script_shebang():
    first_line = SCRIPT_PATH.read_text().splitlines()[0]
    assert first_line == '#!/bin/bash'
