# self-healing-audit: A System That Audits and Repairs Itself on a Trigger

Most rule-based systems rot quietly. Rules drift, contradict each other, and go stale, and nobody notices until something breaks. This one checks itself on a trigger and fixes what it can safely fix.

## The problem

A growing set of rules and config files accumulates drift: duplicated rules, stale references, small contradictions. Periodic manual review is the obvious answer and the one that never actually happens. I wanted the review to fire itself, and to act, not just nag.

## The approach

Two stages, so the cheap part runs often and the expensive part only when warranted, with a strict line on what the system may do while unattended.

## How it works

- **Stage A, a cheap daily trigger check.** It computes two numbers: how many rule changes have happened since the last audit, and how long it has been. If neither threshold is met, it does nothing and says nothing.
- **Stage B, the full audit,** fires only when a threshold trips. It reviews the rule set against a fixed checklist, writes a dated audit report, fixes what is on a safe whitelist, and leaves everything else as numbered findings for a human.
- **Graduated autonomy.** A new audit runs report-only for several cycles, writing the report and paging a digest but changing nothing. Only once its findings prove reliably safe does it graduate to acting, and even then only within a conservative whitelist.

## What it may and may not touch

- **Safe to heal unattended:** archiving clearly-old entries, fixing stale path references, updating stale status flags, resetting the trigger counter.
- **Never unattended (always surfaced):** creating or changing a rule, resolving a contradiction, anything that needs a judgement or a values call.

## Key design decisions

- **Cheap often, expensive rarely.** The daily check is trivial; the full audit sits behind a real trigger, so the system is not paying to review itself every night.
- **Earn autonomy on evidence.** Report-only first, act only once proven. Trust is spent, not granted.
- **Reversible by construction.** Every unattended change runs through a git-backed safe-apply floor (see [safe-apply](../safe-apply/)), so anything it does is one revert away.
- **Silence is a feature.** A run that finds nothing past threshold says nothing, so the only messages are ones worth reading.

## A small example

See [examples/audit-state.json](examples/audit-state.json), the durable trigger state the daily check reads and the audit resets.

## What I learned

The hard part was not the audit, it was deciding what a machine may change while you sleep. Drawing a sharp line between "tidy the old stuff" (safe) and "change a rule" (never) is what made unattended self-healing feel safe rather than reckless.
