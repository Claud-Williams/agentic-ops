# scheduler: A Plain-Text Job Runner for Overnight Work

The quiet workhorse: it runs jobs while I sleep and reports what happened.

## The problem

Cron is powerful but opaque. The schedule lives in one place, the script in another, and there is no natural record of what a job did or whether it was even safe to let it act. I wanted jobs I could read, diff and reason about, with a clear line between "look and tell me" and "go ahead and change things".

## The approach

Make each job a single plain-text file: a little frontmatter for how it should run, and a body that says what to do. A small runner reads the file, runs it in the requested mode, writes a result, and reports a one-line status. Everything about a job lives in one readable place.

## How it works

A job is a Markdown file with frontmatter and a fenced command block:

- `mode: report-only` runs and reports but changes nothing. This is the default.
- `mode: act` is allowed to make changes, and in the full system every act-mode job runs through the [safe-apply](../safe-apply/) floor.

The runner extracts the command, runs it, retries once on failure, and writes a timestamped result. See [jobs/example-tidy-job.md](jobs/example-tidy-job.md) for a working example and run it with:

```bash
bash run_job.sh jobs/example-tidy-job.md
```

## Key design decisions

- **Jobs as text.** A job is reviewable and version-controlled like any other file, so its history and intent are visible.
- **Report-only by default.** A new job proves itself in report-only mode and only graduates to acting once trusted. Autonomy is earned.
- **One retry, then flag.** Transient failures retry once; a real failure surfaces rather than failing silently.
- **Quiet on success.** A job that finds nothing says nothing, so the only messages I get are ones worth reading.

## What I learned

When a job hands its body to an AI model to run, the body has to be a pure instruction. My first agent-run job kept replying "what would you like me to do?" instead of acting, because it was written like a note to a colleague rather than a command. Jobs for a model and notes for a human are different genres, and mixing them quietly breaks the run.
