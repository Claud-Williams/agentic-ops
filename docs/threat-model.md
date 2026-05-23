# Threat model

This system runs unattended and edits files, so it is built to be safe to run
while no one is watching, and safe to publish from. This note sets out the main
threats an agentic system like this faces and how each is mitigated. It
complements the [architecture](architecture.md) and
[SECURITY.md](../SECURITY.md).

## Scope

In scope: the overnight automation loop (scheduler, jobs, the safe-apply floor),
the publish path to the public repository, and the agents that operate the
system. Out of scope: the model providers' own security, and the host operating
system.

## Actors and interfaces

- **Agents** that read state and propose or make changes.
- **Model APIs** the agents call.
- **Tools and the file system** the agents act on, through a narrow, allowlisted
  surface rather than arbitrary commands.
- **The human** (me), who approves anything irreversible.
- **The public repository**, the only thing exposed to the outside world.

## Threats and mitigations

| Threat | What could go wrong | Mitigation |
|---|---|---|
| Prompt injection | Untrusted content steers an agent into an unintended action | Direction-of-action comes only from the operator, never from content; irreversible actions need human approval; agents act through an allowlisted surface, not free-form commands |
| Secret or personal-data leak | Private content reaches the public repository | A publish-time scanner (scrub-gate) blocks secrets, personal data and machine paths; a separate nightly leak-audit re-scans what is actually public and can revert it to private; public content is authored fresh with fictional data, never redacted from real |
| Unsafe autonomous change | An unattended job corrupts or deletes something | Every act-mode change goes through the safe-apply floor: snapshot, apply, verify, then commit or roll back; nothing is more than one step from undo |
| Over-permissioned automation | A job, agent or CI step has more power than it needs | Jobs start read-only and earn the right to act; CI runs with read-only token permissions; a scheduled check verifies the agents' own permissions have not drifted from a safe baseline |
| Drift and stale rules | The rule set quietly rots and starts misbehaving | A self-healing audit checks the rules on a trigger and repairs the safe ones, surfacing the rest for a human |
| Supply chain | A dependency introduces a vulnerability | Dependencies are kept minimal; Dependabot alerts and security updates are enabled on the repository |

## Repository controls

Secret scanning, push protection and Dependabot are enabled on this repository.
CI runs with read-only permissions. Secrets are never committed; configuration
uses examples, not real credentials.

## Defence in depth

No single control is trusted on its own. A secret leak would have to clear the
publish-time scanner and the nightly re-audit; an unsafe change would have to
pass verification and still be one revert from undo; an over-permissioned agent
would have to escape both the allowlisted surface and the permission-drift check.
The aim is that any one failure is caught by the next layer.

## Residual risks, honestly

- Model behaviour changes over time, so prompts and guardrails are checked, not
  assumed stable.
- A scanner catches known patterns; a genuinely novel leak shape could slip a
  single pass, which is why the nightly re-audit exists as a backstop.
- This is a one-person system; it has not been through an external security
  review.
