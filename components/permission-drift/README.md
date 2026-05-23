# permission-drift: checks an agent's permissions haven't drifted from a safe baseline

Autonomous agents are only as safe as the permissions they hold. This is a
scheduled check that those permissions still match a known-good baseline, and
that none of them is something the system must never allow.

## The problem

Permissions creep. You grant an agent one more capability to get a job done,
then another, and over weeks the set of things it is allowed to do quietly grows
past what you would consciously sign off. Nobody decided to give an unattended
agent broad power; it accumulated. In a regulated setting that drift is exactly
what an auditor asks about: can you show that what runs today is still what was
approved.

## The approach

Pin a baseline of approved permissions, then check the live set against it on a
schedule. Anything in the live set that is not in the baseline is flagged as
drift to review. Separately, a hard "never" list names capabilities that must
never be granted whatever the baseline says, so a dangerous permission is caught
even if it somehow made it into the baseline.

## How it works

`permission-drift.sh <baseline> <current>` compares two plain-text lists of
granted permissions and reports:

- **Drift:** every entry in the current set that is not in the baseline.
- **Never-list violations:** any entry matching a hard-coded list of
  always-forbidden capabilities (destructive commands, world-writable changes,
  piping the network straight into a shell).

It exits non-zero if it finds either, so it can run unattended and raise its hand
only when something has changed.

## Key design decisions

- **Baseline plus never-list, not one or the other.** The baseline answers "is
  this still what we approved?"; the never-list answers "is this something we
  would never approve?". You need both: drift you tolerate case by case, and a
  floor you never cross.
- **Plain text, diffable.** Permissions live in plain-text lists so a change is
  visible in a diff and reviewable by a human, not buried in a tool's settings.
- **Report, do not auto-fix.** It surfaces drift for a human to approve or
  revoke. Quietly "correcting" permissions would hide exactly the signal you want
  to see.

## See it work

```bash
bash components/permission-drift/examples/demo.sh
```

Compares a current set that matches the baseline (passes), then one that has
gained an extra permission and a forbidden command (fails on both the drift and
the never-list).

## What I learned

The useful question turned out not to be "is this permission dangerous?" but "did
anyone decide to grant it?". Most drift is harmless individually; the risk is
that it is unreviewed. Making the unreviewed change visible, on a schedule, is
what turns a growing pile of permissions back into a set someone is accountable
for.
