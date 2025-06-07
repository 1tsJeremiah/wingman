#!/usr/bin/env bash
set -euo pipefail

failed=false

for script in devops/scripts/*.sh; do
  echo "Validating $script..."
  read -r first_line < "$script"
  if [[ "$first_line" != "#!/bin/bash" && "$first_line" != "#!/usr/bin/env bash" ]]; then
    echo "Error: $script must start with '#!/bin/bash' or '#!/usr/bin/env bash'"
    failed=true
  fi
  if grep -q $'\r' "$script"; then
    echo "Error: $script has Windows line endings"
    failed=true
  fi
  echo
done

if [ "$failed" = true ]; then
  echo "Validation failed." >&2
  exit 1
fi

echo "All scripts validated successfully."
