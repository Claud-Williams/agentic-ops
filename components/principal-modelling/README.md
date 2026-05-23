# principal-modelling: A System That Learns How Someone Thinks, and Sharpens It

The most useful assistant is not the one that executes fastest. It's the one that learns how a specific person thinks, can act with their judgement when they're not in the room, and pushes that judgement to get sharper over time.

## The problem

Personalisation usually means an assistant that echoes you back. That feels good and helps very little. I wanted the opposite: a partner that can represent me faithfully when I'm away, and challenge me when I'm there, so my own thinking improves rather than being flattered.

## The approach

Separate two things people usually blur: *style* (how someone communicates) and *views* (what they actually believe, and why). Capture both from real evidence over time, and use them in two distinct modes:

- Fidelity: draft and decide as the person would, in their voice.
- Sparring: surface the person's own stated view back to them and pressure-test it, defaulting to a clear position they can react to rather than a neutral summary.

## How it works

- A **style profile** and a separate **views file**. Keeping them apart stops "how they write" contaminating "what they believe".
- **Capture-first, draft-second.** The signal isn't what the assistant proposed; it's what the person changed it to. Every edit and decision is logged as a diff.
- **A calibration loop.** For each decision the system records three things: what the person would *typically* pick (modelled), what careful analysis says is the *better* call, and what they *actually* chose. Logging the actual pick turns the model from a description ("they're probably like this") into something tested ("the model predicted them correctly N times out of M").
- **Active sparring.** The default is a flagged spine ("here's my read, correct me"), not even-handed mush, with harder devil's advocate where it earns its keep.

## Key design decisions

- **Style and views are different concerns** and live in different files.
- **The diff is the data.** Mining the gap between draft and final is how the model sharpens itself, with no hand-written profile to maintain.
- **Test the model, don't just trust it.** The three-view log makes bias visible: if the "better call" keeps beating the person's typical pick, that pattern is itself worth showing them.
- **This one stays private.** A faithful model of a person is powerful and personal, so the populated version is never published. What's public is the pattern, not the person.

## A small example

See [examples/calibration-log.md](examples/calibration-log.md) for the three-view decision log, using a fictional persona.

## What I learned

The aim is to provoke better thinking, not to replace it. An assistant that always agrees is comfortable and useless. The moment it began logging where its "better call" diverged from the person's habit, and surfacing that, it stopped being a mirror and started being a sparring partner.
