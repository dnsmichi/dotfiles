# Add a new tool

Use this template when a new tool needs more than a `Brewfile` line, for example
tracked configuration, a Setup step, or a README Reference section.
Keep internal discussions, links, and screenshots out of this issue, because the
project is public.

## Tool

- Name and website:
- Purpose, and the learning phase it belongs to:
- Replaces or complements:

## Installation and updates

<!-- Brewfile, mise, DMG with built-in updates, or an installer script. -->

## Configuration

<!-- Where the tool stores its configuration, which files are user-owned and
can be linked by setup.sh, and which ones the tool writes itself. -->

## Privacy and telemetry

<!-- Default telemetry and how to opt out. -->

## Proposed changes

1. [ ] Tracked configuration under `.config/`
1. [ ] `setup.sh` links
1. [ ] README: What's inside, Setup step, Reference section
1. [ ] Setup checklist in the README and the `new-macbook-setup` issue template
1. [ ] `AGENTS.md` rules for agents maintaining the configuration

## Verification

<!-- How to confirm the tool works with the tracked configuration. -->

/label ~enhancement
