# leak-audit: re-checks what is already public, and catches the leak that slipped past the gate

The publish-time scanner ([scrub-gate](../scrub-gate/)) stops a leak on the way
out. This is the other half: it re-checks what is already public, on a schedule,
because the risk does not end at the moment of publishing.

## The problem

Things change after you publish. A file gets reclassified as sensitive later. A
new commit adds something. A repo gets flipped to public. And there is a whole
surface a content scanner never sees: the **git history itself**, the author and
committer names, the email addresses, and the commit messages. A push-time gate
that reads files cannot catch a real name or a home path sitting in a commit
author from months ago.

## The approach

Treat "already public" as something to keep auditing, not a box ticked once.
A scheduled job re-scans each public repository and fails on anything it should
not find, so a mistake that slips through, or a file that becomes sensitive
later, is caught within a day rather than living there indefinitely.

## How it works

`leak_audit.sh <git_repo_dir>` runs two checks the publish-time gate does not
cover on its own:

1. **Working tree, again.** Re-scans the files for secrets, home paths and
   identifying data, in case something was added or reclassified since.
2. **Git metadata, across all history.** Scans every commit's author and
   committer name, email and message for the same patterns. This is the part a
   content scanner skips entirely.

It exits non-zero on any hit. In the live system a hit can trigger a
revert-to-private; that step is left out of this public version, which only
reports.

## Key design decisions

- **Defence in depth.** This is deliberately the second of two layers. The
  primary protection is authoring public material from scratch with fictional
  data; the publish-time gate catches the mistake that discipline misses; this
  catches the mistake that changes after publication.
- **Metadata is a first-class surface.** The most common real-world leak in a
  public repo is not in a file, it is a name or a home path in commit metadata.
  Scanning history is the point, not an afterthought.
- **Report first, act second.** It runs read-only and reports. Reverting a live
  repo to private is gated behind an explicit flag, so the audit can run every
  night without ever taking an action on its own.

## See it work

```bash
bash components/leak-audit/examples/demo.sh
```

Requires `git`. Builds a throwaway git repo, audits a clean version (passes),
then adds a commit whose message carries a home path and audits again (fails on
the metadata scan, even though every file is clean).

## What I learned

The first useful finding this caught was not in any file. It was a home path in
an old commit message, exactly the kind of thing you would never spot by reading
the rendered repo, and exactly the kind of thing a hiring manager or a security
reviewer would. Auditing the history, not just the files, is what makes "it's
public now, leave it" a safe thing to say.
