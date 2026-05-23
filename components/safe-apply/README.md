# safe-apply: A Git-Backed Safety Floor for Unattended Changes

This is the piece that makes overnight autonomy safe rather than scary.

## The problem

I wanted a system that could improve itself overnight: tidy files, fix configuration drift, remove redundancy. The risk is obvious. An automated change goes wrong, and I do not notice until it has compounded.

The usual safeguard is to review every change in the morning. That does not hold up. If I cannot reliably read a diff and catch a subtle break, my review is not protection, it is a rubber stamp.

So the safety could not depend on me. It had to be built in.

## The approach

Decouple safety from human review. Instead of trusting each job to be careful, or trusting myself to catch its mistakes, wrap every change in one floor that makes it reversible by construction and verifies it before keeping it.

## How it works

`safe_apply.sh <repo> <verify> -- <apply...>` runs in five steps:

1. **Snapshot.** Commit any pending state so there is a clean, known point to return to.
2. **Record** that point.
3. **Apply** the change.
4. **Verify** the result with a pluggable check (here: all JSON still parses and a key file is intact; in a real project this could be a test suite or a build).
5. **Decide.** If verification passes, commit the change with a one-line rollback hint. If it fails, hard-revert to the snapshot so nothing broken is kept. If nothing changed, say so and stop.

## Key design decisions

- **Verification is the gate, not me.** A change is kept only if an automated check passes. Anything that passes is still one `git revert` from undo, so even a wrong-but-valid change is cheap to reverse.
- **Commit the pre-state first.** Committing pending work as a checkpoint means the revert point is always well defined, even if the working tree was dirty.
- **Reset and clean on failure.** A failed change is removed completely, including any new files it created, so a half-applied change never lingers.
- **Pluggable verify and apply.** The wrapper knows nothing about the job. Any command can be the change; any command can be the check. The safety is generic.

## See it work

```bash
bash examples/demo.sh
```

It spins up a throwaway repo for the fictional Northwind Logistics and runs three scenarios: a good change (committed), a change that corrupts the data file (reverted automatically, file restored exactly), and a no-op (reported as such).

## What I learned

The first time I tested the revert path, my test fixture used a stand-in file that was smaller than the verifier's own sanity threshold, so the run reverted a perfectly good change. The wrapper was right; my test was unrealistic. It was a useful reminder that the verifier is as load-bearing as the change itself: a check that is too loose lets breakage through, and one that is too strict blocks good work. Verification deserves the same care as the thing it is guarding.
