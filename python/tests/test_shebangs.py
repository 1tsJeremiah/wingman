<<<<<<< ours
import os

SCRIPT_PATH = os.path.join('devops', 'scripts', 'executable_deploy-landscape-script.sh')


def test_deploy_landscape_script_shebang():
    with open(SCRIPT_PATH, 'r') as f:
        first_line = f.readline().strip()
    assert first_line == '#!/bin/bash'
=======
from pathlib import Path

SCRIPT_PATH = Path(__file__).resolve().parents[2] / "devops" / "scripts" / "executable_deploy-landscape-script.sh"

def test_script_has_shebang():
    first_line = SCRIPT_PATH.read_text().splitlines()[0]
    assert first_line.startswith("#!")
>>>>>>> theirs
