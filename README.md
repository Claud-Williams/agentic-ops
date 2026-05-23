# Agentic Operations System

A self-improving, self-healing automation system I built to run my own daily
operations, and to keep itself lean, safe, and honest while it does.

Most automation rots. Scripts pile up, config drifts, files bloat, and nobody
notices until something breaks or the usage bill arrives. I wanted the opposite:
a system that reviews itself every night, fixes what it can safely fix, flags
what it cannot, and never makes a change it cannot instantly undo.

This repository is a curated, public extract. The architecture and code are
real; the sample data is fictional (see the note at the bottom).

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

- **[safe-apply](components/safe-apply/)** — the git-backed safety floor. Wraps
  any unattended file change so a failed result is reverted automatically and a
  good one is a single commit from undo. This is the piece that makes overnight
  autonomy safe rather than scary.
- **[scrub-gate](components/scrub-gate/)** — a publish-time scanner that blocks
  secrets, personal data, and home-machine paths from ever reaching a public
  repository.
- **[scheduler](components/scheduler/)** — the overnight job runner: plain-text
  jobs, read-only or act mode, with retry and reporting.
- **[principal-modelling](components/principal-modelling/)** — learns how a person
  thinks, can act with their judgement, and actively sharpens it over time.
- **[self-healing-audit](components/self-healing-audit/)** — audits its own rules
  for drift on a trigger and repairs the safe ones, earning autonomy gradually.
- **[handoff-architecture](components/handoff-architecture/)** — how several agents
  across devices stay in sync: read everyone's state, write only your own.
- **[calibration-method](components/calibration-method/)** — logs predicted versus
  actual effort and feeds the bands back, so estimates correct themselves.
- **[dashboard](components/dashboard/)** — one live view of the whole system, a
  projection of plain-text source files (with a static, fake-data demo).

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
