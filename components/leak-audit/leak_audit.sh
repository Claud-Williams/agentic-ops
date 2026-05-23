#!/usr/bin/env bash
# leak_audit.sh <git_repo_dir>
#
# Re-audits a repository that is ALREADY public, as the backstop to the
# publish-time scrub gate. It checks two things the publish-time gate does not
# cover on its own:
#   1. the working tree again (a file may have been added or reclassified), and
#   2. git metadata - author / committer name, email and commit messages, across
#      ALL history - which a content scanner never reads.
# Exits non-zero on any hit. In the live system a hit can trigger a
# revert-to-private; this version only reports.
#
# Customise the identity pattern below with your own real name, handles and path.
set -u
REPO="${1:-}"
[ -n "$REPO" ] && [ -d "$REPO/.git" ] || { echo "usage: leak_audit.sh <git_repo_dir>" >&2; exit 2; }

SECRET='-----BEGIN [A-Z ]*PRIVATE KEY-----|AKIA[0-9A-Z]{16}'
HOMEPATH='/(Users|home)/[A-Za-z0-9._-]+'
IDENTITY='EXAMPLE_NAME|example-handle'           # replace with your own
PAT="$SECRET|$HOMEPATH|$IDENTITY"

hits=0
echo "=== leak-audit: $REPO ==="

echo "--- 1. working tree (file content) ---"
out="$(grep -rInI --exclude-dir=.git -E -e "$PAT" "$REPO" 2>/dev/null)" || true
if [ -n "$out" ]; then printf '%s\n' "$out" | sed 's/^/    /' | head -20; hits=$((hits+1)); else echo "    clean"; fi

echo "--- 2. git metadata (author / committer / email / messages, all history) ---"
meta="$(cd "$REPO" && git log --all --format='%an | %ae | %cn | %ce | %B' 2>/dev/null)"
mout="$(printf '%s\n' "$meta" | grep -nE -e "$PAT" 2>/dev/null)" || true
if [ -n "$mout" ]; then printf '%s\n' "$mout" | sed 's/^/    /' | head -20; hits=$((hits+1)); else echo "    clean"; fi

echo "=== verdict ==="
if [ "$hits" -gt 0 ]; then echo "RESULT: FAIL - public content needs attention (in the live system, revert to private)."; exit 1; fi
echo "RESULT: PASS - nothing public that should not be."; exit 0
