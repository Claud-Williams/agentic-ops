#!/usr/bin/env bash
# verify.sh [repo_dir]
#
# An example verification to pair with safe_apply.sh. It answers one question:
# "is the repository still healthy after the change?" Here that means every
# tracked JSON file still parses and a key data file is present and non-trivial.
#
# Swap these checks for whatever "still healthy" means in your project (tests
# pass, a build succeeds, a schema validates). Exit 0 = healthy; non-zero = broken.
set -u
DIR="${1:-.}"
cd "$DIR" || exit 2
RC=0

# 1. Every tracked JSON file still parses.
while IFS= read -r f; do
    [ -f "$f" ] || continue
    python3 -c "import json,sys; json.load(open(sys.argv[1]))" "$f" 2>/dev/null \
        || { echo "BROKEN JSON: $f"; RC=1; }
done < <(git ls-files '*.json' 2>/dev/null)

# 2. A key data file is present and non-trivial (> 50 bytes).
KEY="data/inventory.json"
if [ -f "$KEY" ]; then
    sz=$(wc -c < "$KEY")
    [ "$sz" -gt 50 ] || { echo "SUSPICIOUS: $KEY only ${sz} bytes"; RC=1; }
fi

[ "$RC" -eq 0 ] && echo "verify: OK"
exit "$RC"
