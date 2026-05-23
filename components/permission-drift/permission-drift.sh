#!/usr/bin/env bash
# permission-drift.sh <baseline_file> <current_file>
#
# Checks that an agent's granted permissions have not drifted from a known-safe
# baseline, and that none of them matches a hard "never" list. Designed to run on
# a schedule. Exits non-zero on drift or a never-list hit, and only reports - it
# never changes permissions itself.
#
# Each file is a plain-text list of granted permissions, one per line.
set -u
BASE="${1:-}"; CUR="${2:-}"
[ -f "$BASE" ] && [ -f "$CUR" ] || { echo "usage: permission-drift.sh <baseline> <current>" >&2; exit 2; }

# Capabilities that must NEVER be granted, whatever the baseline says.
NEVER='rm[[:space:]]+-rf[[:space:]]+/|chmod[[:space:]]+-R[[:space:]]+777|curl.*\|[[:space:]]*sh|:\(\)\{'

drift=0
echo "=== permission-drift ==="

echo "--- new permissions not in the baseline ---"
new="$(comm -13 <(sort -u "$BASE") <(sort -u "$CUR"))"
if [ -n "$new" ]; then printf '%s\n' "$new" | sed 's/^/    + /'; drift=$((drift+1)); else echo "    none"; fi

echo "--- never-list violations ---"
viol="$(grep -E "$NEVER" "$CUR" 2>/dev/null)" || true
if [ -n "$viol" ]; then printf '%s\n' "$viol" | sed 's/^/    !! /'; drift=$((drift+1)); else echo "    none"; fi

echo "=== verdict ==="
if [ "$drift" -gt 0 ]; then echo "RESULT: FAIL - permissions drifted from the safe baseline; review before the next unattended run."; exit 1; fi
echo "RESULT: PASS - permissions match the safe baseline."; exit 0
