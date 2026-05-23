# scrub-gate: a publish-time gate that keeps secrets and personal data out of anything you make public

This is the gate that stands between private work and a public repository.

## The problem

Publishing useful work means constantly deciding what is safe to show. Do that by hand and eventually something slips: a hard-coded path, an email address, an internal name, a key. The cost of one leak is high and effectively permanent, because search engines, clones and forks make a public mistake very hard to take back.

## The approach

Make the safe path the default and the unsafe path impossible to take by accident. Nothing reaches the public repository until an automated scanner has read every file and found nothing it should not. The scan is a hard gate, not a friendly warning.

## How it works

`scrub_gate.sh <dir>` scans a directory and sorts what it finds into two buckets:

- **Block:** secrets, home-machine paths, and identifying names. Any hit fails the gate and stops the publish.
- **Warn:** things worth a glance, such as any email address or IP, that do not block on their own.

It exits non-zero on any block, so it can sit in front of a push as a precondition that simply has to pass.

## Key design decisions

- **Two layers, not one.** This gate runs at publish time; a sibling job re-scans what is already public every night, so a later mistake or a reclassified file is still caught. Defence in depth.
- **Block versus warn.** Hard-blocking every email would be too noisy to live with; clear secrets and identifying data block, while ambiguous signals only warn.
- **A backstop, not the main defence.** The primary protection is that public material is written from scratch with fictional sample data. The gate exists to catch the mistake that the discipline misses.

## See it work

```bash
bash components/scrub-gate/examples/demo.sh
```

Runs the scanner over a clean sample (passes) and over a sample with a planted key and home path (blocked).

## What I learned

The first time I ran this over my own code, it found dozens of files carrying a hard-coded home path I had never consciously noticed. That settled the argument for me: you cannot eyeball this reliably, which is exactly why it has to be a gate a machine enforces, not a habit a human maintains.
