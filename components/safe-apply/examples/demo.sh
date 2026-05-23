#!/usr/bin/env bash
# demo.sh - runnable demonstration of safe_apply.sh.
#
# Sets up a throwaway git repo for the fictional "Northwind Logistics" and runs
# three scenarios so you can watch the safety floor work:
#   1. a good change      -> verified and committed
#   2. a change that breaks the data -> automatically reverted
#   3. a change that does nothing     -> reported as no-op
#
# Usage: bash demo.sh
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMP="$(cd "$HERE/.." && pwd)"
REPO="$(mktemp -d)"

cd "$REPO"
git init -q && git config user.email demo@example.com && git config user.name demo
mkdir -p data
cat > data/inventory.json <<'JSON'
{ "owner": "Jordan Vale", "company": "Northwind Logistics",
  "warehouses": [ { "id": "NW-1", "pallets": 120 } ] }
JSON
git add -A && git commit -q -m "baseline"

VERIFY="bash '$COMP/verify.sh' '$REPO'"

echo "############ 1. GOOD CHANGE (expect APPLIED) ############"
SAFE_APPLY_TAG=demo bash "$COMP/safe_apply.sh" "$REPO" "$VERIFY" -- \
  bash -c 'python3 - <<PY
import json
d = json.load(open("data/inventory.json"))
d["warehouses"].append({"id": "NW-2", "pallets": 80})
json.dump(d, open("data/inventory.json","w"), indent=2)
print("added warehouse NW-2")
PY'

echo; echo "############ 2. BREAKING CHANGE (expect REVERTED) ############"
SAFE_APPLY_TAG=demo bash "$COMP/safe_apply.sh" "$REPO" "$VERIFY" -- \
  bash -c 'echo "this is not valid json {" > data/inventory.json; echo "corrupted the file"'

echo; echo "############ 3. NO-OP (expect NO-CHANGE) ############"
SAFE_APPLY_TAG=demo bash "$COMP/safe_apply.sh" "$REPO" "$VERIFY" -- true

echo; echo "Final inventory.json (should still be valid, with NW-1 and NW-2):"
cat "$REPO/data/inventory.json"
rm -rf "$REPO"
