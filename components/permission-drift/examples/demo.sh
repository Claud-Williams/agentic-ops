#!/usr/bin/env bash
# demo.sh - shows permission-drift.sh passing a current set that matches the
# baseline, then failing one that has gained an unreviewed permission and a
# forbidden command.
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOL="$HERE/../permission-drift.sh"
TMP="$(mktemp -d)"

cat > "$TMP/baseline" <<'EOF'
read:files
write:workspace
run:tests
network:allowlist
EOF

cp "$TMP/baseline" "$TMP/current_ok"

cat > "$TMP/current_drifted" <<'EOF'
read:files
write:workspace
run:tests
network:allowlist
write:system
rm -rf /var/data
EOF

echo "===== current matches the baseline (expect PASS) ====="
bash "$TOOL" "$TMP/baseline" "$TMP/current_ok"; echo "exit=$?"
echo
echo "===== current has drifted: an extra permission + a forbidden command (expect FAIL) ====="
bash "$TOOL" "$TMP/baseline" "$TMP/current_drifted"; echo "exit=$?"

rm -rf "$TMP"
