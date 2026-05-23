#!/usr/bin/env bash
# safe_apply.sh <repo_dir> <verify_cmd> -- <apply_cmd...>
#
# A git-backed safety floor for unattended file changes. It makes any automated
# edit reversible by construction, so a system can change files while you sleep
# without that being a gamble:
#
#   1. ensure a clean git base (commit any pre-existing changes as a checkpoint)
#   2. record the pre-apply commit
#   3. run the apply command (the change you want to make)
#   4. run the verify command
#   5. verify PASS + changes -> commit them      (rollback = git revert <hash>)
#      verify FAIL           -> hard-revert to the pre-apply commit (nothing kept)
#      no changes            -> report and exit cleanly
#
# Every outcome prints a plain-English summary suitable for a morning report.
set -u

REPO="${1:-}"; shift || true
VERIFY="${1:-}"; shift || true
if [ "${1:-}" = "--" ]; then shift; fi
APPLY=("$@")

[ -n "$REPO" ] && [ -d "$REPO" ] || { echo "usage: safe_apply.sh <repo_dir> <verify_cmd> -- <apply_cmd...>" >&2; exit 2; }
[ -n "$VERIFY" ] || { echo "safe_apply: missing verify command" >&2; exit 2; }
[ "${#APPLY[@]}" -gt 0 ] || { echo "safe_apply: missing apply command (after --)" >&2; exit 2; }

cd "$REPO" || exit 2
git rev-parse --git-dir >/dev/null 2>&1 || { echo "safe_apply: $REPO is not a git repo" >&2; exit 2; }

JOB_TAG="${SAFE_APPLY_TAG:-auto-change}"
STAMP="$(date '+%Y-%m-%d %H:%M:%S %Z')"

# 1. Clean base, so the revert point is well-defined.
if [ -n "$(git status --porcelain)" ]; then
    git add -A
    git commit -q -m "$JOB_TAG: pre-apply checkpoint ($STAMP)" || true
fi
PRE="$(git rev-parse HEAD)"

# 3. Run the apply command.
echo "safe_apply: running apply command..."
APPLY_OUT="$( "${APPLY[@]}" 2>&1 )"; APPLY_RC=$?

# Surface the apply's own output before the verdict, so a report carries the
# job's headline rather than only safe_apply's result line.
echo "----- apply output -----"
printf '%s\n' "$APPLY_OUT"
echo "----- end apply output -----"

# Did anything actually change?
if [ -z "$(git status --porcelain)" ]; then
    echo "RESULT: NO-CHANGE — apply made no edits (apply rc=$APPLY_RC)."
    exit 0
fi

# 4. Verify.
echo "safe_apply: verifying..."
VERIFY_OUT="$( bash -c "$VERIFY" 2>&1 )"; VERIFY_RC=$?
CHANGED_FILES="$(git status --porcelain | sed 's/^/    /')"

# 5. Commit on pass, revert on fail.
if [ "$VERIFY_RC" -eq 0 ] && [ "$APPLY_RC" -eq 0 ]; then
    git add -A
    git commit -q -m "$JOB_TAG: applied ($STAMP)"
    NEW="$(git rev-parse --short HEAD)"
    echo "RESULT: APPLIED — verified clean, committed $NEW."
    echo "Roll back with: git -C \"$REPO\" revert $NEW"
    echo "Files changed:"; echo "$CHANGED_FILES"
    exit 0
else
    git reset -q --hard "$PRE"
    git clean -fdq
    echo "RESULT: REVERTED — verify rc=$VERIFY_RC, apply rc=$APPLY_RC; restored to $PRE. Nothing kept."
    echo "Verify output:"; printf '%s\n' "$VERIFY_OUT" | sed 's/^/    /' | head -20
    exit 1
fi
