#!/bin/bash

## vimhelp-html.bash ::
# Generate a decent looking vim help in html.
# - use runtime/doc/makehtml.awk script included with vim
# - add ascii heading (figlet)
# - add css classes and clean up various things with sed

## config ::
link_css="../../css/main.css"
dir_html="$UDIR/sync/www/vim/help"
dir_vim="$UDIR/git/vim"
dir_faq="$UDIR/git/vim_faq"

nav_help='<nav>
    <a href="index.html">index</a>
    <a href="quickref.html">quickref</a>
    <a href="usr_toc.html">usr_toc</a>
    <a href="vim_faq.html">vim_faq</a>
</nav>'

nav_main='<nav>
    <a href="../../index.html">about</a>
    <a href="../../help/arch-usb.html">arch-usb</a>
    <a href="../../bindi/index.html">bindi</a>
    <a href="http://valleycat.org" target="_blank">valleycat</a>
    <span class="active">vim</span>
    <a href="https://github.com/arcmags/ramroot" target="_blank">ramroot</a>
    <a href="https://arxiv.org/pdf/1610.01011.pdf" target="_blank">symmetry</a>
</nav><hr class="nomargin">'

sed_cmds=(
  '/<PRE>/{N;s/\n$//}'
  '/^<A HREF="#top">.*/d'
  's@</head>@<link rel="stylesheet" href="'"${link_css}"'">\n</head>@i'
  's@<title>vim documentation: (.*)</title>@<title>Vim: \1\.txt</title>@i'
  's@<body[^>]*>@\n<body class="term">@i'
  's@^\|(<a href[^>]*>[^>]*>)\|@\1  @gi'
  's@\|(<a href[^>]*>[^>]*>)\|@\1@gi'
  's@(\*?(Todo|Notes?))@<span class="warn">\1</span>@g'
  's@(\*?(Errors?))@<span class="error">\1</span>@g'
  's@^([=-]{4,})@<span class="bold comment">\1</span>@i'
  's@(<b>)?<font color="purple">(<b>)?(.*)(</b>)?</font>(</b>)?@<span class="heading">\3</span>@i'
  's@\*(<a name="[^"]*"></a>)<b>([^<]*)</b>\*@\1<span class="heading">\2</span>@gi'
  's@^([A-Z][A-Z0-9_: -]*)$@<span class="heading">\1</span>@'
  's@^([A-Z][A-Z0-9_ -]*:)(.*)@<span class="heading">\1</span>\2@'
  's@YXXY@|@g'
  's@\t@ @g'
)

## internal ::
footer=
hash_faq=
hash_vim=
html=
sed_args=()
text=
title=

## main ::
set -e

# error: vim git directory not found:
if [ ! -d "$dir_vim" ]; then
    printf 'E: vim directory not found\n' >&2
    return 1
fi
# error: figlet not found:
if ! command -v figlet &>/dev/null; then
    printf 'E: missing required program: figlet\n' >&2
    return 1
fi
# error: git not found:
if ! command -v git &>/dev/null; then
    printf 'E: missing required program: git' >&2
    return 1
fi

# pull vim_faq:
cd "$dir_faq"
git pull
hash_faq="$(git rev-parse --verify HEAD)"

# pull vim and configure make:
cd "$dir_vim"
git restore runtime/doc*.txt runtime/doc/tags runtime/doc/Makefile
git pull
hash_vim="$(git rev-parse --verify HEAD)"
make config

# compile html docs:
cd "$dir_vim/runtime/doc"
make clean
cd "$dir_vim/runtime"
[ -d doc_build~ ] && rm -r doc_build~
[ -d doc_build ] && mv doc_build doc_build~
cp -r doc doc_build
cp "$dir_faq/doc/vim_faq.txt" doc_build
cd doc_build
sed -i -E -e 's/(@if test -f errors.log.*)/#\1/' \
  -e 's/^(\s*workshop\.)(html|txt)/\1\2 vim_faq.\2/' Makefile
for txt in *.txt; do
    expand "$txt" > tmp_xxx.txt
    mv tmp_xxx.txt "$txt"
done
make html

# modify html docs:
cd "$dir_vim/runtime/doc_build"

for cmd in "${sed_cmds[@]}"; do
    sed_args+=(-e "$cmd")
done

for html in *.html; do
    title="$(grep -Poi '<h1>vim documentation: \K[^<]*' "$html")"
    text="${html%.*}.txt"
    if [ "$html" = 'index.html' ]; then
        text='help.txt'
    elif [ "$html" = 'vimindex.html' ]; then
        text='index.txt'
    fi
    footer="<footer>"$'\n'"<a href=\"$text\" target=\"_blank\">$text</a> "
    footer+='generated from <a href="https://github.com'
    if [ "$html" = 'vim_faq.html' ]; then
        footer+='/chrisbra/vim_faq/tree/'"$hash_faq"'">'"${hash_faq:0:7}"
    else
        footer+='/vim/vim/tree/'"${hash_vim}"'">'"${hash_vim:0:7}"
    fi
    footer+="</a> on $(date +'%F %H:%M:%S')"$'\n'
    { printf '<!DOCTYPE html>\n<!-- vim/help/%s -->\n\n' "$html"
    sed -E '/<BODY.*>.*/q' "$html"
    printf '<header>\n'
    printf '%s\n' "$nav_main"
    sed -E 's/.*'"${html}"'.*/    <span class="active">'"${html%.*}"'<\/span>/' <<<"$nav_help"
    printf '<pre>\n'
    figlet -f slant2 "$title" | sed -E -e 's/ *$//' -e '/^ *$/d' \
      -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'
    printf '</pre>\n</header>\n\n'
    sed -n '/<HR>/, /<\/BODY>/{ /<HR>/! { /<\/BODY>/! p } }' "$html"
    printf '%s\n' "$footer"
    printf '\n</body>\n</html>\n' ;} > tmp.txt
    sed -E "${sed_args[@]}" tmp.txt > "$html"
done

# additions:
{ sed -E '/.*LOCAL ADDITIONS.*/q' index.html
printf '<a href="vim_faq.html">vim_faq.txt</a>        Frequently Asked Questions\n'
sed '0,/.*LOCAL ADDITIONS.*/d' index.html ;} > tmp.txt
mv tmp.txt index.html

# fixes:
sed -i -E 's@(ft_context\.txt</a>) *@\1  @i' index.html
sed -i -E 's@("heading">) *shiftwidth=4@\1  shiftwidth=4@i' options.html
sed -i -E 's@\|(netrw-[^|]*)\|@<a href="#\1">\1</a>@i' pi_netrw.html
sed -i -E 's@(<a href=[^>]*>[^>]*>)( *)  @\1\2@i' vim_faq.html

mkdir -p "$dir_html"
cp *.html *.txt "$dir_html"

printf 'I: finished with no errors\n'
