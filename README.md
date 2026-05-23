<p align="left">
  <img src="docs/wordmark.svg" alt="agentic-ops" width="280">
</p>

<p align="left">
  <a href="https://claud-williams.github.io/agentic-ops/"><img src="https://img.shields.io/badge/live%20demo-online-2f6f6a" alt="live demo"></a>
  <a href="https://github.com/Claud-Williams/agentic-ops/actions/workflows/ci.yml"><img src="https://github.com/Claud-Williams/agentic-ops/actions/workflows/ci.yml/badge.svg" alt="ci"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="licence: MIT"></a>
  <img src="https://img.shields.io/github/last-commit/Claud-Williams/agentic-ops" alt="last commit">
</p>

# Agentic Operations System

A self-improving, self-healing automation system I built to run my own daily
operations, and to keep itself lean, safe, and honest while it does.

Most automation rots. Scripts pile up, config drifts, files bloat, and nobody
notices until something breaks or the usage bill arrives. I wanted the opposite:
a system that reviews itself every night, fixes what it can safely fix, flags
what it cannot, and never makes a change it cannot instantly undo.

This repository is a curated, public extract. The architecture and code are
real; the sample data is fictional (see the note at the bottom).

**▶ [View the live dashboard demo](https://claud-williams.github.io/agentic-ops/components/dashboard/examples/demo/index.html)** (interactive, wired to fictional sample data).

## What this is, and what it isn't

This is a curated public showcase, not a product you clone and run. The real system runs against my own files and machine and stays private. What's public is the architecture, the working code for each component, and a dashboard demo you can use in the browser, wired to fictional data.

- **Reproducibility.** The demo runs as-is in any browser. The components are real and readable, but the full system is not a one-command install. It is documented so you can understand the design and build your own version, not download mine.
- **How it's evaluated, and how it fails.** The system measures itself rather than assuming it works: calibration-method tracks predicted-versus-actual effort, safe-apply verifies every change or rolls it back, and self-healing-audit catches its own drift.
- **Limitations, honestly.** It is tuned to one person's workflow; several components are documented designs rather than packaged tools; and the demo is illustrative, not a benchmark.

If you want to see how it is operated day to day, the [agentic-method](components/agentic-method/) component shows the actual prompts, jobs and handoffs (sanitised), and [SECURITY.md](SECURITY.md) covers how to report a problem.

## Why I built it

I lead operations for a living and taught myself agentic engineering to automate
the parts of my own work that a capable assistant should handle. Four ideas shaped
every design decision:

- **Compounding beats rewriting.** Small, safe improvements applied every night
  add up faster than occasional big overhauls.
- **Autonomy is only safe if it is reversible.** A system can run unattended only
  if every change it makes is verified and one step from undo.
- **A self-reviewing system must pay for itself.** An assistant that reviews its
  own work can easily burn more compute than it saves, so the review measures and
  reports its own net saving.
- **Unattended work must be honest.** Anything that runs while I sleep leaves a
  full, reviewable trail, so I can always see what changed and why.

## How it works

A lightweight scheduler runs jobs overnight. Each job is a plain-text file that
describes what to do. A runner executes it either read-only, where it only
reports, or in act mode, where it changes files. Every act-mode change passes
through a git-backed safety floor: the system snapshots the current state,
applies the change, verifies the result, then either commits it or rolls it
straight back. A publish gate scans anything bound for public release for secrets
and personal data before it can leave. A dashboard surfaces what happened and
what still needs a human.

See [docs/architecture.md](docs/architecture.md) for the full picture.

## Components

- **[dashboard](components/dashboard/)** - one live view of the whole system, a
  projection of plain-text source files. **[View the live demo](https://claud-williams.github.io/agentic-ops/components/dashboard/examples/demo/index.html)** (static, fictional sample data).
- **[self-healing-audit](components/self-healing-audit/)** - audits its own rules
  for drift on a trigger and repairs the safe ones, earning autonomy gradually.
- **[safe-apply](components/safe-apply/)** - the git-backed safety floor. Wraps
  any unattended file change so a failed result is reverted automatically and a
  good one is a single commit from undo. This is the piece that makes overnight
  autonomy safe rather than scary.
- **[agentic-method](components/agentic-method/)** - how the system is actually
  operated: the prompts (as structured prompt cards), the job files, the
  cross-agent handoffs, and the multi-model research intake, all sanitised.
- **[principal-modelling](components/principal-modelling/)** - learns how a person
  thinks, can act with their judgement, and actively sharpens it over time.
- **[scheduler](components/scheduler/)** - the overnight job runner: plain-text
  jobs, read-only or act mode, with retry and reporting.
- **[scrub-gate](components/scrub-gate/)** - a publish-time scanner that blocks
  secrets, personal data, and home-machine paths from ever reaching a public
  repository.
- **[leak-audit](components/leak-audit/)** - the backstop to scrub-gate:
  re-scans what is already public on a schedule, including git history and
  metadata, and can revert a repo to private if something slipped through.
- **[permission-drift](components/permission-drift/)** - checks an agent's
  granted permissions still match a safe baseline, and never include anything on
  a hard "never" list.
- **[handoff-architecture](components/handoff-architecture/)** - how several agents
  across devices stay in sync: read everyone's state, write only your own.
- **[calibration-method](components/calibration-method/)** - logs predicted versus
  actual effort and feeds the bands back, so estimates correct themselves.

## Running the demos

The components are plain shell scripts, so the demos run on macOS and Linux with
no setup beyond tools you almost certainly already have. The reference
environment is Ubuntu, which is what CI runs on every push.

- **All demos** need a `bash` shell and standard Unix tools (`grep`, `sed`,
  `sort`, `comm`, `mktemp`), which macOS and Linux include by default.
- **safe-apply** and **leak-audit** also use **git**.
- **safe-apply** also uses **python3** (to validate JSON in its verify step).
- On **Windows**, run the demos under WSL or Git Bash.

Each component's "See it work" gives the exact command, which is the same command
CI runs, so anything documented here is continuously tested.

## Safety and security

This system runs unattended and edits files, so security is designed in, not
bolted on. The threats an agentic system faces, and how this one mitigates them,
are written up in [docs/threat-model.md](docs/threat-model.md). In short:

- **Reversibility over trust.** Every unattended change goes through the
  [safe-apply](components/safe-apply/) floor: verified, then committed or rolled
  straight back. Nothing it does is more than one step from undo.
- **Defence in depth on anything public.** The
  [scrub-gate](components/scrub-gate/) scanner blocks secrets and personal data
  before publication, and a separate nightly
  [leak-audit](components/leak-audit/) re-scans what is already public, history
  and all, and can pull it back to private if anything slips through.
- **Least privilege, continuously checked.** Jobs start read-only and earn the
  right to act; CI runs with read-only permissions; and a scheduled
  [permission-drift](components/permission-drift/) check verifies the agents' own
  permissions have not drifted from a safe baseline.
- **Repository controls on.** Secret scanning, push protection and Dependabot are
  enabled here; [SECURITY.md](SECURITY.md) covers how to report a problem.

## Principles that run through it

- Reversible, or it does not ship.
- Verify before you trust.
- Earn autonomy gradually: every job starts report-only and graduates to acting
  only once it has proven safe.
- Prove the saving, do not assume it.
- Always leave a trail.

## A note on what is public here

This is a deliberately curated extract. Personal data, private operations, and
anything identifying live in a separate private repository and never flow here
automatically. Sample data throughout uses a fictional persona, Jordan Vale at
the fictional Northwind Logistics, and resembles no real person or organisation.
