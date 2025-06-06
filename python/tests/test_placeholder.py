from pathlib import Path
import yaml


def test_docker_compose_has_no_conflict_markers():
    compose_path = Path(__file__).resolve().parents[2] / "docker-compose.yml"
    content = compose_path.read_text()
    assert "<<<<<<<" not in content and ">>>>>>>" not in content
    yaml.safe_load(content)
