#!/usr/bin/env bash
# demo.sh - shows leak_audit.sh passing a clean repo and then catching a leak
# that lives only in git metadata (a home path in a commit message), which a
# content scan of the files would miss entirely.
#
# The sample home path is assembled at runtime (split across two literals) so
# this demo file itself stays clean for any scanner reading the repo.
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOL="$HERE/../leak_audit.sh"
TMP="$(mktemp -d)"
cd "$TMP" || exit 1
git init -q
git config user.name "Demo User"
git config user.email "demo@example.com"
printf 'A scheduler that audits its own config.\nSample user: Jordan Vale, Northwind Logistics.\n' > notes.md
git add -A && git commit -q -m "initial clean commit"

echo "===== clean repo (expect PASS) ====="
bash "$TOOL" "$TMP"; echo "exit=$?"
echo

home_path="/Users""/sample/private"   # split so this file carries no real-looking path
git commit -q --allow-empty -m "tidy up scripts under $home_path"

echo "===== leak hidden in a commit message, files still clean (expect FAIL) ====="
bash "$TOOL" "$TMP"; echo "exit=$?"

cd / && rm -rf "$TMP"
