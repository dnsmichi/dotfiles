#!/bin/bash
# UserPromptSubmit hook: rename the current herdr tab to "Review <iid>" or
# "MR <iid>" when the prompt references a GitLab MR.

[ -n "${HERDR_PANE_ID:-}" ] || exit 0
command -v herdr >/dev/null && command -v jq >/dev/null || exit 0

prompt="$(jq -r '.prompt // empty')"
[ -n "$prompt" ] || exit 0

iid="$(printf '%s' "$prompt" | grep -oE '/-/merge_requests/[0-9]+' | head -1 | grep -oE '[0-9]+$')"
[ -n "$iid" ] || iid="$(printf '%s' "$prompt" | grep -oE '(^|[^[:alnum:]])![0-9]+' | head -1 | grep -oE '[0-9]+$')"
[ -n "$iid" ] || iid="$(printf '%s' "$prompt" | grep -oiE '\b(MR|review(ing)?)[[:space:]]+#?[0-9]+' | head -1 | grep -oE '[0-9]+$')"
[ -n "$iid" ] || exit 0

if printf '%s' "$prompt" | grep -qiE 'review'; then
  name="Review $iid"
else
  name="MR $iid"
fi

tab_id="$(herdr pane get "$HERDR_PANE_ID" 2>/dev/null | jq -r '.result.pane.tab_id // empty')"
[ -n "$tab_id" ] || exit 0
label="$(herdr tab get "$tab_id" 2>/dev/null | jq -r '.result.tab.label // empty')"

# Only name tabs still on herdr's default numeric label, so a later prompt that
# mentions some other MR doesn't rename a tab that's already named.
printf '%s' "$label" | grep -qE '^[0-9]+$' || exit 0

herdr tab rename "$tab_id" "$name" >/dev/null 2>&1
exit 0