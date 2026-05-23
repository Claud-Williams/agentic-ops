# handoff-architecture: Coordinating Several Agents Across Devices

I run agents on more than one surface: a desktop assistant, a command-line agent, and a phone. This is how they stay in sync without stepping on each other.

## The problem

Work moves between contexts. Something started on the desktop is best finished by the command-line agent; a decision needs making from my phone. Without coordination, each surface has a partial, stale picture, and two of them editing the same state corrupts it.

## The approach

Shared, plain-text handoff files as the single source of truth, with one ownership rule that removes write conflicts entirely: everyone reads all of them, but each surface writes only its own.

## How it works

- One handoff file per surface (desktop, command line, mobile). At the start of any session, a surface reads all of them, so it knows what every other surface is doing.
- A surface only ever writes to its own file. Because no two surfaces write the same file, there are no lost updates and no locks.
- One exception: any surface may prune an entry from another's file once it has actioned it, so finished items do not pile up.
- Files are kept readable in a single pass; old entries are archived rather than left to bloat.

## Key design decisions

- **Read-all, write-own.** The whole concurrency problem disappears with this one rule. No database, no locking.
- **Plain text, not a database.** Handoffs are human-readable and diffable, so I can see the state at a glance and so can each agent.
- **Readable in five minutes.** A handoff that takes longer to read than the task it saves is worse than nothing, so size is actively managed.
- **Timestamp and a one-line topic per entry**, so the next reader orients instantly.

## A small example

See [examples/handoff.md](examples/handoff.md) for the shape of one surface's handoff file.

## What I learned

The instinct is to reach for a shared database and locking. The far simpler answer, which scaled fine across three surfaces, was append-to-your-own-file plus read-everyone-else's. A lot of coordination problems are really ownership problems in disguise.
