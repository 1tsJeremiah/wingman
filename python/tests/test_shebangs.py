from pathlib import Path

# Determine the repository root relative to this file so tests work when
# executed from any directory.
SCRIPT_PATH = (
    Path(__file__).resolve().parents[2]
    / 'devops'
    / 'scripts'
    / 'executable_deploy-landscape-script.sh'
)


def test_deploy_landscape_script_shebang():
    with open(SCRIPT_PATH, 'r') as f:
        first_line = f.readline().strip()
    assert first_line == '#!/bin/bash'
