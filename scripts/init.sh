#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 The Fisher Slopworks Co
# SPDX-License-Identifier: AGPL-3.0-or-later
#
# One-shot initializer for a repository created from the Slopworks template.
# Fills in the project name/tagline, writes a fresh project README, removes this
# script, and verifies REUSE compliance.
#
# Usage:
#   ./scripts/init.sh                       # interactive prompts
#   ./scripts/init.sh "My Project" "A short tagline."
#   PROJECT_NAME="My Project" PROJECT_TAGLINE="..." ./scripts/init.sh

set -euo pipefail

# --- locate repo root (parent of this script's directory) -------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT"

# --- derive a sensible default project name ---------------------------------
default_name=""
if remote="$(git remote get-url origin 2>/dev/null)"; then
  default_name="$(basename "${remote%.git}")"
fi
[ -n "$default_name" ] || default_name="$(basename "$ROOT")"

# --- gather inputs: args > env > interactive prompt -------------------------
PROJECT_NAME="${1:-${PROJECT_NAME:-}}"
PROJECT_TAGLINE="${2:-${PROJECT_TAGLINE:-}}"

if [ -z "$PROJECT_NAME" ]; then
  printf 'Project name [%s]: ' "$default_name"
  read -r PROJECT_NAME || true
  PROJECT_NAME="${PROJECT_NAME:-$default_name}"
fi
if [ -z "$PROJECT_TAGLINE" ]; then
  printf 'One-line tagline: '
  read -r PROJECT_TAGLINE || true
fi
PROJECT_TAGLINE="${PROJECT_TAGLINE:-$PROJECT_NAME}"

# --- escape a string for safe use as a sed replacement ----------------------
sed_escape() { printf '%s' "$1" | sed -e 's/[&|\\]/\\&/g'; }
esc_name="$(sed_escape "$PROJECT_NAME")"
esc_tagline="$(sed_escape "$PROJECT_TAGLINE")"

# --- substitute placeholders in the governance files ------------------------
for f in SECURITY.md CONTRIBUTING.md; do
  [ -f "$f" ] || continue
  sed -i "s|{{PROJECT_NAME}}|$esc_name|g; s|{{PROJECT_TAGLINE}}|$esc_tagline|g" "$f"
done

# --- write a fresh project README (replaces the template's own README) ------
cat > README.md <<EOF
<!--
SPDX-FileCopyrightText: 2026 The Fisher Slopworks Co
SPDX-License-Identifier: AGPL-3.0-or-later
-->

# $PROJECT_NAME

$PROJECT_TAGLINE

## License

$PROJECT_NAME is licensed under [AGPL-3.0-or-later](LICENSE) and is
[REUSE](https://reuse.software/)-compliant.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md), the [Code of Conduct](CODE_OF_CONDUCT.md),
and the [security policy](SECURITY.md).
EOF

# --- remove this initializer (and scripts/ if now empty) --------------------
rm -f "$SCRIPT_DIR/init.sh"
rmdir "$SCRIPT_DIR" 2>/dev/null || true

# --- verify compliance ------------------------------------------------------
echo
echo "Initialized '$PROJECT_NAME'."
if command -v reuse >/dev/null 2>&1; then
  echo "Running 'reuse lint'..."
  reuse lint || {
    echo "WARNING: reuse lint reported issues — please review before committing." >&2
  }
else
  echo "Note: 'reuse' is not installed; skipping the compliance check."
  echo "Install it (https://reuse.software/) and run 'reuse lint' before committing."
fi

echo
echo "Next steps:"
echo "  1. Edit README.md, CONTRIBUTING.md (setup/test commands), and SECURITY.md."
echo "  2. Add SPDX headers to new source files (see CONTRIBUTING.md)."
echo "  3. git add -A && git commit"
