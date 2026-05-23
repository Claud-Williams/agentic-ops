---
mode: report-only
schedule: daily 04:00
---
# Example job: large-file report

Reports the largest files in the project so bloat gets noticed early, before it
slows things down. Report-only: it looks and tells, it changes nothing.

```bash
find . -type f -size +1M -not -path '*/.git/*' -printf '%s\t%p\n' 2>/dev/null \
  | sort -rn | head -10 \
  | awk '{printf "  %6.1f MB  %s\n", $1/1048576, $2}'
echo "(report-only: nothing was changed)"
```
