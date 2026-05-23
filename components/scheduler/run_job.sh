#!/usr/bin/env bash
# run_job.sh <job.md>
#
# Minimal plain-text job runner. Reads a job Markdown file with simple frontmatter,
# runs its first fenced bash block, writes a result, and prints a one-line status.
# Frontmatter key: mode (report-only | act). Retries once on failure.
set -u
JOB="${1:-}"
[ -f "$JOB" ] || { echo "usage: run_job.sh <job.md>" >&2; exit 2; }

# Read a frontmatter key, e.g. "mode: act" -> "act".
fm() { sed -n "s/^$1: *//p" "$JOB" | head -1; }
mode="$(fm mode)"; [ -n "$mode" ] || mode="report-only"

# Extract the first ```bash ... ``` fenced block as the command to run.
cmd="$(awk '/^```bash/{f=1;next} /^```/{f=0} f' "$JOB")"
[ -n "$cmd" ] || { echo "no bash block found in $JOB" >&2; exit 2; }

stamp="$(date '+%Y-%m-%d %H:%M:%S')"
out="$(bash -c "$cmd" 2>&1)"; rc=$?
if [ "$rc" -ne 0 ]; then sleep 2; out="$(bash -c "$cmd" 2>&1)"; rc=$?; fi   # one retry

echo "job:  $JOB"
echo "when: $stamp   mode: $mode   exit: $rc"
echo "output:"; printf '%s\n' "$out" | sed 's/^/    /'
[ "$rc" -eq 0 ] && echo "STATUS: ok" || echo "STATUS: failed"
exit "$rc"
