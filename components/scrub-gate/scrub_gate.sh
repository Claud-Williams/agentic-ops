#!/usr/bin/env bash
# scrub_gate.sh <target_dir>
#
# Publish-time scanner. Scans <target_dir> and FAILS (non-zero exit) on any
# block-level hit, so it can guard a push as a precondition. Warn-level hits are
# printed for review but do not block.
#
# Customise the "identity" line below with your own real names, handles and paths.
set -u
TARGET="${1:-}"
[ -n "$TARGET" ] && [ -d "$TARGET" ] || { echo "usage: scrub_gate.sh <target_dir>" >&2; exit 2; }

GREP=(grep -rInI --exclude-dir=.git --exclude=scrub_gate.sh --exclude=leak_audit.sh --exclude=permission-drift.sh)
BLOCK=0; WARN=0

scan() {  # <bucket> <label> <regex>
    local bucket="$1" label="$2" rx="$3" out
    # -e is required: some patterns begin with a dash and grep would otherwise
    # read them as options and silently no-op.
    out="$("${GREP[@]}" -E -e "$rx" "$TARGET" 2>/dev/null)" || true
    [ -n "$out" ] || return 0
    echo "${bucket}: ${label}"
    printf '%s\n' "$out" | sed 's/^/    /' | head -30; echo
    if [ "$bucket" = "BLOCK" ]; then BLOCK=$((BLOCK+1)); else WARN=$((WARN+1)); fi
}

echo "=== scrub_gate: scanning $TARGET ==="; echo

# --- secrets (always block) ---
# Bare-marker private-key detection (gitleaks rule). Catches every PEM-style
# BEGIN ... PRIVATE KEY marker (RSA / EC / OPENSSH / ENCRYPTED / PGP BLOCK
# variants, etc.) regardless of body, line length, or whether an END follows -
# so encrypted keys, EC keys with short lines, and truncated keys all block.
# Prose mentions of the marker also block by design: handle false-positives at
# the source (reword the line) or via a targeted allowlist, not by weakening
# detection.
scan BLOCK "private key material"  '-----BEGIN[ A-Z0-9_-]{0,100}PRIVATE KEY( BLOCK)?-----'
scan BLOCK "aws access key id"     'AKIA[0-9A-Z]{16}'
scan BLOCK "assigned secret/token" '(api[_-]?key|secret|password|token)[" '"'"']*[:=][" '"'"']*[A-Za-z0-9/_+.-]{12,}'

# --- home-machine paths (block) ---
scan BLOCK "home path"             '/(Users|home)/[A-Za-z0-9._-]+'

# --- identity: CUSTOMISE with your own real name / handles (block) ---
scan BLOCK "identity (customise)"  'YOUR-REAL-NAME|your-github-handle'

# --- warn-level: review, do not block ---
scan WARN  "email address"         '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'
scan WARN  "non-localhost IPv4"    '\b(([0-9]{1,3}\.){3}[0-9]{1,3})\b'

echo "=== verdict ==="
echo "BLOCK: $BLOCK   WARN: $WARN"
if [ "$BLOCK" -gt 0 ]; then echo "RESULT: FAIL - publish blocked."; exit 1; fi
echo "RESULT: PASS"; exit 0
