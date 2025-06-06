#!/bin/bash
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

echo "[3/5] 🛠 Fixing docker-compose Traefik conflict markers"
git apply --3way <<'PATCH'
diff --git a/docker-compose.yml b/docker-compose.yml
index 847d353..65d557a 100644
--- a/docker-compose.yml
+++ b/docker-compose.yml
@@ -2,35 +2,31 @@
 version: "3.9"
 
 services:
   traefik:
     image: traefik:v2.11
     container_name: traefik
     restart: always
     ports:
       - "80:80"
       - "443:443"
       - "8081:8080"
     command:
       - "--api.dashboard=true"
       - "--entrypoints.web.address=:80"
       - "--entrypoints.websecure.address=:443"
       - "--providers.docker=true"
       - "--providers.docker.exposedbydefault=false"
       - "--certificatesresolvers.myresolver.acme.httpchallenge=true"
       - "--certificatesresolvers.myresolver.acme.httpchallenge.entrypoint=web"
       - "--certificatesresolvers.myresolver.acme.email=${ACME_EMAIL}"
       - "--certificatesresolvers.myresolver.acme.storage=/letsencrypt/acme.json"
     volumes:
       - /var/run/docker.sock:/var/run/docker.sock:ro
       - traefik_letsencrypt:/letsencrypt
     labels:
       - "traefik.enable=true"
       - "traefik.http.routers.traefik.rule=Host(${TRAEFIK_DOMAIN_PREFIX}.pegasuswingman.com)"
       - "traefik.http.routers.traefik.entrypoints=web"
       - "traefik.http.routers.traefik.service=api@internal"
 
 volumes:
   traefik_letsencrypt:
PATCH

echo "[4/5] 🛠 Fixing deploy_edge_agent.sh shebang + history expansion"
git apply --3way <<'PATCH'
diff --git a/scripts/executable_deploy_edge_agent.sh b/scripts/executable_deploy_edge_agent.sh
index fb4309b..436e000 100644
--- a/scripts/executable_deploy_edge_agent.sh
+++ b/scripts/executable_deploy_edge_agent.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 set -euo pipefail
-set +H  # Disable history expansion for zsh
+set +H  # Disable history expansion
PATCH

echo "[5/5] 🧪 Add test to verify docker-compose has no conflict markers"
git apply --3way <<'PATCH'
diff --git a/python/tests/test_placeholder.py b/python/tests/test_placeholder.py
index 3ada1ee..645939f 100644
--- a/python/tests/test_placeholder.py
+++ b/python/tests/test_placeholder.py
@@ -1,2 +1,9 @@
-def test_placeholder():
-    assert True
+from pathlib import Path
+import yaml
+
+def test_docker_compose_has_no_conflict_markers():
+    compose_path = Path(__file__).resolve().parents[2] / "docker-compose.yml"
+    content = compose_path.read_text()
+    assert "<<<<<<<" not in content and ">>>>>>>" not in content
+    yaml.safe_load(content)
PATCH

echo "✅ All 3 patches applied successfully."
