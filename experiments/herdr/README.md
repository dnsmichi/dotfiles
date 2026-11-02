# Herdr experiments

Untested ideas for [Herdr](../../README.md#herdr). Nothing here is linked by
`setup.sh` or registered as a Claude Code hook.

## Rename tabs after the merge request

[herdr-tab-mr-name.sh](herdr-tab-mr-name.sh) is a copy of the public snippet
[herdr auto rename hook](https://gitlab.com/jessieay/jessieay/-/snippets/6073662)
by Jessie Young, unchanged apart from a header with the source and credit. As a Claude Code `UserPromptSubmit` hook, it renames a Herdr tab
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

## GitLab Duo CLI agent status

Herdr lists a terminal as an agent only when its program reports
[OSC 7501](https://www.superlogical.com/rex/docs/build/program-status), for
example `ESC ]7501;state=blocked:kind=permission:app=gitlab-duo:msg=<base64> ESC \`.
Findings so far:

1. herdr-core answers the probe `OSC 7501 ; ?` with
   `?:states=idle,working,done,blocked,error:kinds=permission,question,auth`, and
   also accepts reports sent without the probe.
1. A test terminal printing `state=blocked:kind=question` showed up in `hc get`,
   and the parent agent received a "blocked (question)" notification.
1. Duo CLI 10.0.0 does not report status yet, and its hooks offer only
   `SessionStart`, so a hook cannot report `working` or `blocked`.
1. [gitlab-lsp#3431](https://gitlab.com/gitlab-org/editor-extensions/gitlab-lsp/-/work_items/3431)
   and [gitlab-lsp!4587](https://gitlab.com/gitlab-org/editor-extensions/gitlab-lsp/-/merge_requests/4587)
   add it with `app=gitlab-duo` and a base64-encoded `msg`, written to `/dev/tty`.
   [gitlab-lsp#3496](https://gitlab.com/gitlab-org/editor-extensions/gitlab-lsp/-/work_items/3496)
   follows up on `blocked` for headless runs.
1. The `gitlab-duo` entry in [programs.json](../../.config/herdr-app/programs.json)
   gives the reported agent a name and icon, and starts it from the `+` menu.

Not tested yet: a build of !4587 running inside Herdr. That needs the
gitlab-lsp toolchain (Bun 1.4.4 through mise) and a worktree of its `osc-7501` branch.
