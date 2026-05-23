# dashboard: a personal operating system in one calm live view, projected from the files the agents already use

The piece I've iterated on most. One page that pulls everything I'm running, across every organisation and role I work in and my personal life, into a single calm view. It's a projection of plain-text files, grown over many rounds of real use.

> **Status: work in progress.** This is the most actively-evolving part of the system. What's shown here is a faithful snapshot of the current direction and the interactions, not a finished product. The system itself keeps evolving.

## The problem

Once you automate across dozens of files, jobs and contexts, the state scatters. What's open, what ran overnight, what needs me, what's coming. Answering "what's going on?" meant opening a dozen files, which defeats the point of automating anything.

## The architecture

A small local service exposes a strict, allowlisted file API (read, list, and a narrow write, bound to localhost only) over the same plain-text files the agents use. A view layer renders those files into one page. The source files stay the single source of truth; the dashboard is only a projection of them, so it can never drift out of sync. It is moving toward a local web app reached privately over a VPN, so I can check it from any of my devices without anything leaving my own network.

## What it surfaces (selected)

- A **daily briefing** front door, a day page rather than a monitoring screen: a priority-ranked top set, a Top-3 band, and a needs-you count.
- **Context enrichment** (the highest-value feature): terse, agent-written items and codenames are followed back to their source and translated into plain language, who it involves, what it relates to, when it arrived and how old it is. The list stays readable as it grows.
- **Home-and-spokes navigation** across organisations and life domains, each its own view, with a quiet "ways of working" reference.
- A **system-health bar**, green / amber / red, that names the issue.
- **Routines** with due / overdue state and an owner (me, automated, or shared) that pause themselves when I'm out of office.
- A **Heartbeat** view of every scheduled job: when it last ran, whether it succeeded, and whether it's allowed to interrupt me or is dashboard-only.
- **Recent activity** across each agent surface, a **Kanban roadmap**, self-clearing **maintenance tasks**, and **tag filtering**.

## How it evolved (the part I'm proud of)

It started as a single plain scrolling page. Then I used it, kept noting what didn't help, and rebuilt from the feedback. Over many rounds it became:

- a **calm daily briefing** rather than a wall of data, where one thing is the focal point and everything else is visibly secondary;
- a **human-friendly rendering layer**, so the source files stay machine-appropriate and the surface becomes human-appropriate: one source, two renderings, never two copies to drift;
- **context-enriched**, turning codenames and agent shorthand into plain who / what / when;
- organised **home-and-spokes** across every organisation and my personal life;
- and most recently an **items-as-objects** model, where every view is a projection of one object set, plus **phase / readiness tracking** that shows where a project is on its journey and what it takes to advance.

Visually it travelled from plain, to a calm-tech aesthetic, to a warmer editorial identity with a ranked masthead, and a dedicated visual-identity redesign is underway. The story of this page is iteration, and it will keep improving.

## Key design decisions

- **Projection, not a second source of truth.** It reads the files and never stores state, so it cannot lie.
- **One source, two renderings.** Machine-appropriate files in, human-appropriate view out. No duplicate human copies to maintain.
- **Briefing, not cockpit.** Calm by default, detail on demand. Every element has to tell me something I can act on, or it's cut.
- **Local-first and private.** It runs against my own files and never leaves my network.

## See it (the visual evolution)

**▶ [View the live demo](https://claud-williams.github.io/agentic-ops/components/dashboard/examples/demo/index.html)** - the current version, interactive, in your browser. ([the early version](https://claud-williams.github.io/agentic-ops/components/dashboard/examples/demo/early.html), for the contrast.)

- [examples/demo/index.html](examples/demo/index.html) (source) - closer to where it is now: a calm two-accent briefing where teal is the one interactive accent and a warm clay marks only the ranked Top-3 band. Type-coded chips (area, type, who, age), a priority-ranked top set, a health bar that names the issue, cockpit area views grouped by who acts, routines, a heartbeat of every scheduled job, and a kanban roadmap. The same item shows in several views, because every view is a projection of one object set.
- [examples/demo/early.html](examples/demo/early.html) (source) - roughly where it started: a plain single page.

Both are wired only to fake data (the fictional Jordan Vale at Northwind Logistics), so they are safe to share or host on GitHub Pages. The live links above render via GitHub Pages.

## What I learned

The features mattered less than the rendering layer. Keeping source files machine-appropriate and translating to human-appropriate at the surface is what made it usable. And the realisation that a personal operating system is a *briefing* you read each morning, not a monitoring screen you stare at, is what made it calm instead of noisy.
