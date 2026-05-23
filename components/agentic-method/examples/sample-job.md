# Sample job: weekly supplier SLA sweep

> A scheduled job as a plain-text file. Jobs are plain text so they are easy to
> read, diff, and review before they are trusted to act. Fictional example
> (Northwind Logistics).

```yaml
name: supplier-sla-sweep
cadence: weekly
day: Mon
hour: 7
mode: report        # report = read-only; act = may change files (gated)
runner: shell
report: dashboard   # where the result is surfaced
enabled: true
```

## What it does

Each Monday at 07:00 it checks the top suppliers against their service-level
targets and writes a short result: how many were checked, how many are below
threshold, and which ones. It only reports; it never changes anything.

## How it reports

The result is a few lines of plain text that the dashboard reads and shows on
the Heartbeat view, with a green or amber dot. A human decides what to do about
any supplier that is flagged.

## Why report-only first

Every job starts in report-only mode and has to earn the right to act. Only once
it has run cleanly for a while, and a human has read the results, would it be
considered for act mode, and even then under the safety floor (see
[safe-apply](../../safe-apply/)).
