import os

SCRIPT_PATH = os.path.join('devops', 'scripts', 'executable_deploy-landscape-script.sh')


def test_deploy_landscape_script_shebang():
    with open(SCRIPT_PATH, 'r') as f:
        first_line = f.readline().strip()
    assert first_line == '#!/bin/bash'
