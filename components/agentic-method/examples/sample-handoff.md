# Sample handoff entry

> How one agent hands state to the next across surfaces (a desktop assistant, a
> command-line agent, a phone). The rule: read everyone's state, write only your
> own. Fictional example (Northwind Logistics). See the
> [handoff-architecture](../../handoff-architecture/) component for the why.

---

## Desktop assistant handoff, 14:05, depot rota work

**Done this session.** Reconciled the two depot rotas that had overlapping
shifts; the corrected rota is ready for the depot lead's sign-off before Friday's
payroll cut-off.

**State.** The rota change is staged, not yet approved. Nothing has been pushed
to the live schedule.

**For the command-line agent.** When the sign-off lands, run the payroll export
job (currently report-only) and check the totals before anything goes live.

**For the phone agent.** If the depot lead asks about the rota while away from a
desk, the short answer is: corrected, waiting on their approval, no action needed
from them until then.

**Pending the human.** One decision: approve the rota change, or send it back
with notes.
