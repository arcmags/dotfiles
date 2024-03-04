#!/bin/sh
## ~/.config/fzf/profile.sh ::

export FZF_DEFAULT_COMMAND="find -type f -printf '%P\n'"
export FZF_DEFAULT_OPTS="--bind 'alt-a:first' \
  --bind 'alt-d:half-page-down' \
  --bind 'alt-e:last' \
  --bind 'alt-n:page-down' \
  --bind 'alt-p:page-up' \
  --bind 'alt-u:half-page-up' \
  --bind 'alt-v:toggle-preview' \
  --bind 'backward-eof:ignore' \
  --bind 'ctrl-d:delete-char' \
  --color='bg+:4' \
  --color='bg:-1' \
  --color='border:8:bold' \
  --color='disabled:8' \
  --color='fg+:10:regular' \
  --color='fg:-1' \
  --color='gutter:-1' \
  --color='header:12:bold' \
  --color='hl+:13:regular' \
  --color='hl:13' \
  --color='info:12' \
  --color='label:8:bold' \
  --color='marker:10:bold' \
  --color='pointer:10:bold' \
  --color='preview-bg:-1' \
  --color='preview-fg:-1' \
  --color='prompt:10:bold' \
  --color='query:15:regular' \
  --color='separator:8:bold' \
  --color='spinner:12:bold' \
  --height 60% \
  --marker='*' \
  --no-separator \
  --no-unicode \
  --preview-window hidden \
  --preview='cat {}'"
