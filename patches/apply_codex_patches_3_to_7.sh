#!/bin/bash
set -euo pipefail

ROOT=$(git rev-parse --show-toplevel)
cd "$ROOT"

echo "[3] Fixing docker-compose Traefik config and conflict markers"
git apply --3way <<'PATCH'
diff --git a/docker-compose.yml b/docker-compose.yml
index 847d353383fd384009a3092da4a9dbacad770d66..65d557ac949444b755cb959f53442b6aa7ca447c 100644
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

echo "[4] Patch: fix shebang and cleanup in deploy_edge_agent"
git apply --3way <<'PATCH'
diff --git a/scripts/executable_deploy_edge_agent.sh b/scripts/executable_deploy_edge_agent.sh
index fb4309bebbc6548c65559ebe8f4384b839fdf35b..436e000176f7873717c936001df9b9f526ccd269 100644
--- a/scripts/executable_deploy_edge_agent.sh
+++ b/scripts/executable_deploy_edge_agent.sh
@@ -1,28 +1,28 @@
 #!/bin/bash
 set -euo pipefail
-set +H  # Disable history expansion for zsh
+set +H  # Disable history expansion
PATCH

echo "[5] Patch: placeholder test to validate docker-compose has no conflict markers"
git apply --3way <<'PATCH'
diff --git a/python/tests/test_placeholder.py b/python/tests/test_placeholder.py
index 3ada1ee4e585a4b2664b66ace385ea172f9e769e..645939f981b4aae89bc7f3f8daee7e4afbc6f3aa 100644
--- a/python/tests/test_placeholder.py
+++ b/python/tests/test_placeholder.py
@@ -1,2 +1,9 @@
-def test_placeholder():
-    assert True
+from pathlib import Path
+import yaml
+
+
+def test_docker_compose_has_no_conflict_markers():
+    compose_path = Path(__file__).resolve().parents[2] / "docker-compose.yml"
+    content = compose_path.read_text()
+    assert "<<<<<<<" not in content and ">>>>>>>" not in content
+    yaml.safe_load(content)
PATCH

echo "[✅] All patches (3–5) applied successfully."
