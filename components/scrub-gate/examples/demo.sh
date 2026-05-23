#!/usr/bin/env bash
# demo.sh - shows scrub_gate.sh passing clean content and blocking a leak.
#
# Note: the sample "leak" strings are assembled at runtime (split across two
# literals) so this demo file itself stays clean for any scanner reading the repo.
# A secret scanner that fails on its own test fixtures is a classic foot-gun.
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GATE="$HERE/../scrub_gate.sh"
TMP="$(mktemp -d)"
mkdir -p "$TMP/clean" "$TMP/dirty"

printf 'A scheduler that audits its own config.\nSample user: Jordan Vale, Northwind Logistics.\n' > "$TMP/clean/notes.md"

fake_key="AKIA""IOSFODNN7EXAMPLE"      # AWS docs example key, split so it is not a literal here
home_path="/Users""/someone/private"   # split so this file carries no real home path
{ printf 'aws_key = "%s"\n' "$fake_key"
  printf 'backup_path = "%s"\n' "$home_path"; } > "$TMP/dirty/leak.txt"

echo "===== clean content (expect PASS) ====="
bash "$GATE" "$TMP/clean"; echo "exit=$?"
echo
echo "===== content with a planted key + home path (expect FAIL) ====="
bash "$GATE" "$TMP/dirty"; echo "exit=$?"

rm -rf "$TMP"
