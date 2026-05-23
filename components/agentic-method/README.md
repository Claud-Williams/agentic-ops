# agentic-method: how the system is actually operated, in prompts, jobs, handoffs and research

Most of an agentic system's behaviour does not live in code. It lives in the
prompts that direct the agents, the jobs they run on a schedule, the handoffs
that keep several agents in sync, and the way new knowledge is brought in and
checked. This component shows how I document and operate those, because for
agentic work that discipline is the engineering.

> Everything here is sanitised and fictional (Jordan Vale at the fictional
> Northwind Logistics, the same persona as the dashboard demo). The real prompts
> and state stay private; what is shown is the *form* and the judgement behind
> it, not live content.

## Why document the method, not just dump the prompts

Raw prompts are long, brittle, and easy to copy without understanding. They also
change as models change, so a prompt on its own is not stable proof of anything.
The more useful, and more honest, artefact is a structured description: what the
prompt is for, what it expects, how it is checked, and what is deliberately left
out. That is what a prompt card is, and it travels far better than a wall of
text.

## What's here

- **[prompt-card.md](examples/prompt-card.md)** - a structured prompt card:
  intent, inputs, guardrails, how it is evaluated, and what is withheld. The
  format I use instead of publishing raw prompts.
- **[sample-job.md](examples/sample-job.md)** - a scheduled job as a plain-text
  file: when it fires, whether it only reports or is allowed to act, and how it
  reports back. Jobs are plain text so they are reviewable and diffable.
- **[sample-handoff.md](examples/sample-handoff.md)** - how one agent hands state
  to another across surfaces: read everyone's state, write only your own. (See
  also the [handoff-architecture](../handoff-architecture/) component.)
- **[research-intake.md](examples/research-intake.md)** - the convention for
  bringing in outside research from several AI models, filing it, and feeding it
  into a decision, so it never floats loose.

## The principles behind all of it

- Plain text first, so everything is readable, diffable, and reviewable by a
  human.
- Structured over raw, so an artefact says what it is for and how it is checked,
  not just what it says.
- Sanitise at the boundary, so nothing private leaves the private system (see
  [scrub-gate](../scrub-gate/)).
- Write for the next person, including future me.
