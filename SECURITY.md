# Security policy

This is a public, curated showcase repository. It contains no production
credentials, customer data, or live infrastructure: the real system runs
privately against my own machine and files, and all sample data here is
fictional.

## Reporting a problem

If you spot a security issue, a leaked secret, or any personal data that should
not be here, please report it privately rather than opening a public issue:

- Use GitHub's private vulnerability reporting on this repository (the Security
  tab, "Report a vulnerability"), or
- Contact me through the link on my GitHub profile.

I will acknowledge reports promptly and act on anything genuine.

## How this repository protects itself

- A publish-time scanner (see the [scrub-gate](components/scrub-gate/) component)
  checks for secrets, personal data and machine paths before anything is made
  public.
- A nightly check scans what is actually public for the same patterns, as a
  backstop.
- Unattended changes run through a git-backed safety floor (see the
  [safe-apply](components/safe-apply/) component): every change is verified and
  one step from undo.

## Supported use

The code here illustrates an architecture and the design decisions behind it. It
is not a packaged product and carries no warranty; treat it as a reference, not
a dependency.
