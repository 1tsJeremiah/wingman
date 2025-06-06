from pathlib import Path

SCRIPT_PATH = Path(__file__).resolve().parents[2] / "devops" / "scripts" / "executable_deploy-landscape-script.sh"

def test_script_has_shebang():
    first_line = SCRIPT_PATH.read_text().splitlines()[0]
    assert first_line.startswith("#!")
