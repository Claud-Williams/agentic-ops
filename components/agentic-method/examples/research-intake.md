# Research intake: bringing outside research in, and not losing it

> The convention for commissioning research across several AI models, filing it,
> and feeding it into a decision, so it never floats loose. Fictional example
> (Northwind Logistics).

## The problem

It is easy to ask an AI model a big research question, get a long answer, and
then lose it: it sits in a chat, never filed, never compared, never turned into a
decision.

## The convention

1. **Commission with a brief.** Write the research question as a short brief, so
   the same question can be run in more than one model and compared.
2. **Give it a home before the answer arrives.** Create a folder for the topic
   with a `brief/` and an `outputs/`, and drop a plain-language marker in
   `outputs/` saying what the research is, what decision it will feed, and where
   to report back, so it is obvious even weeks later.
3. **File every source the same way.** Each returned report is renamed to
   `<topic>__<source>__<date>` and logged in a central index, one row per topic,
   so several models' answers to the same question sit side by side.
4. **Feed a decision, then prune.** Once the research has informed a decision,
   record which decision it fed and clear the marker.

## A fictional example

> **Topic:** depot-automation-vendors. **Brief:** which warehouse-automation
> vendors fit our depot footprint, on cost, integration effort and support?
> **Sources:** two models, compared. **Decision it fed:** the Phase 2 automation
> shortlist. **Status:** filed and closed.

## Why this matters

Running the same question through more than one model, and filing the answers the
same way, turns scattered AI output into something a team can trust and revisit.
It is a small discipline that compounds.
