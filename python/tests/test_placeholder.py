from pathlib import Path
import yaml


def test_docker_compose_has_no_conflict_markers():
    """Ensure docker-compose.yml contains no merge conflict markers."""
    compose_file = Path(__file__).resolve().parents[2] / "docker-compose.yml"
    content = compose_file.read_text()

    assert "<<<<<<<" not in content
    assert ">>>>>>>" not in content

    yaml.safe_load(content)
