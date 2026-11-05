---
name: screenshot-redaction
description: Redact personal data from screenshots with solid ImageMagick boxes before they go into docs, merge requests, issues, or slides. Use when asked to redact, anonymize, or hide usernames, emails, user IDs in URLs, avatars, IP addresses, tokens, or customer names in an image. Do not use for editing photos, creating or capturing screenshots, or redacting text documents.
---

# Screenshot Redaction

Use this skill to cover sensitive data in a screenshot before it is shared.
Do not use it for editing photos, creating or capturing screenshots, or redacting text documents.

## Prerequisites

ImageMagick 7 provides the `magick` command: `brew install imagemagick`.
In the dotfiles repository, it is already listed in `Brewfile`.

## Workflow

1. Ask for the image path, and what must stay readable, such as status marks,
   counts, or summaries.
2. View the image. List every sensitive item with its location, and ask the user
   to confirm the list. When in doubt, flag it. Typical items:
   usernames and display names, email addresses, user or project IDs in URLs,
   avatars, IP addresses and private hostnames, tokens and keys, customer names.
3. Find coordinates by measuring, never by guessing (see below).
4. Draw solid boxes. Never blur or pixelate text: both can be reversed.
5. Write to a new file, never over the original. View the result, and confirm
   that every item is covered and nothing that must stay readable is hidden.
6. Remind the user that Git history and earlier merge request diff versions keep
   the unredacted file. Removing it needs a squash on merge or a history rewrite.
7. Update alt text and captions to say what was redacted, for example
   "Pipeline list, with usernames and email addresses redacted".

## Find coordinates

Get the image size first. Retina screenshots are often twice the size they look:

```shell
magick identify -format '%wx%h\n' in.png
```

Locate anchors, such as a colored status icon, by masking a color and scanning.
The mask turns matching pixels white; `-scale Wx1!` collapses every column into
one pixel, so the non-black entries are the columns that contain the color.
Use `-scale 1xH!` for rows. For an 800x400 image and green icons:

```shell
mask() {
  magick in.png -alpha off -fx '(g>0.5 && r<0.3) ? 1 : 0' -scale "$1" \
    -threshold 0 -depth 8 txt:- | rg -v '^#' | rg -v '#000000'
}
mask 800x1! | cut -d, -f1                 # columns, x
mask 1x400! | cut -d: -f1 | cut -d, -f2   # rows, y
```

To measure a line of text, crop its band with `-crop WxH+X+Y +repage` before
masking, for example `r>0.7` for light text on a dark theme. Offsets inside the
crop are relative: add the crop's X and Y. Pad each box by 2 to 4 pixels.

## Draw boxes

Pick a fill color that fits the theme, slightly off the background so the box
reads as a redaction, for example `#4a4d52` on a dark theme or `#d0d0d0` on a
light one. Add one `-draw` per box:

```shell
magick in.png -fill '#4a4d52' \
  -draw 'rectangle 56,42 400,68' \
  -draw 'rectangle 56,102 420,126' \
  in-redacted.png
```

Cover a whole value, not only part of it: a partial email or token still leaks.
Cover avatars completely, because faces and initials identify people.

## Test image

A made-up screenshot to practice on, with no real data: 800x400, dark background
`#1f1f1f`, light text `#e0e0e0`. Lines: `jdoe-example  jane.doe@example.com`,
`https://gitlab.example.com/users/123456`, `192.0.2.10   glpat-EXAMPLEEXAMPLE`,
then two green status dots (`#2da160`) followed by `Pipeline passed: 12 jobs`
and `Acme Example Corp`. Expected result: the first three lines and the customer
name are boxed; the status dots and `Pipeline passed: 12 jobs` stay readable.

## Decision standard

When unsure whether something identifies a person, a customer, or a system,
cover it and say so. A box too many is cheaper than a leak.
