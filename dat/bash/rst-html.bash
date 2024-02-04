#!/bin/bash

# rst-html.bash ::

css="$UDIR/.user/.config/docutils/arcDark.css"
for rst in "$@"; do
    rst2html --stylesheet="$css" "$rst" > "${rst%%.*}.html"
done
