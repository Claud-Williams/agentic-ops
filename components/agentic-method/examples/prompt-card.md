# Prompt card: morning operations briefing

> A structured description of a prompt, the format I publish instead of raw
> prompt text. Fictional example (Northwind Logistics).

**Intent.** Each weekday morning, produce a short operations briefing for the
depot lead: what needs them today, what is overdue, and what ran overnight. Calm
and skimmable, never alarmist.

**Inputs.**

- The open-items file (tasks, decisions, who acts).
- The overnight job results (what ran, pass or fail).
- The routines file (what is due).

**Output.** A ranked "needs you" list (at most the top few), a one-line health
summary, and a short "also worth knowing" section. Plain language, no jargon.

**Guardrails.**

- Rank by importance first, then urgency; never bury a safety or compliance item
  under noise.
- State uncertainty plainly; do not invent numbers.
- If nothing needs the reader, say so. A quiet briefing is a good briefing.

**How it's evaluated.** A weekly check compares the briefing's "needs you" list
against what the reader actually actioned, and against anything that was missed.
Drift in either direction is a signal to adjust the prompt.

**What's withheld.** The real briefing reads private operational files and names
real people; this card shows the shape and the rules, not that content.
