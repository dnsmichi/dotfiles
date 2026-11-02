# Herdr experiments

Untested ideas for [Herdr](../../README.md#herdr). Nothing here is linked by
`setup.sh` or registered as a Claude Code hook.

## Rename tabs after the merge request

[herdr-tab-mr-name.sh](herdr-tab-mr-name.sh) is a verbatim copy of the public
snippet [herdr auto rename hook](https://gitlab.com/jessieay/jessieay/-/snippets/6073662)
by Jessie Young. As a Claude Code `UserPromptSubmit` hook, it renames a Herdr tab
that still has its default number to `Review <iid>` or `MR <iid>` when the prompt
references a GitLab merge request.

Open points before using it:

1. The script targets the Herdr TUI: it calls the `herdr` CLI and reads
   `HERDR_PANE_ID`. The Herdr app provides `herdr-app do tab.rename` and `hc`
   instead, so the script exits without renaming anything there.
1. Session titles should also describe issues and work items, including
   confidential ones. Tab titles stay local, but they show up in screen shares
   and screenshots, so confidential items need a title that does not reveal
   their content.
