#!/bin/sh

source $(pwd | cut -d'/' -f1,2,3,4)/site.cfg

pintitle=$(grep "title: " pinned.md | cut -d'"' -f2)
pinlink=$(readlink pinned.md | sed 's/.md/.html/g' | cut -d'/' -f2,3)
pintease=$(cat pinned.md | sed -e '1,/^$/d' | sed '/^$/,$d')

echo "<div id=\"pinned\">
## [$pintitle]($pinlink)

<div class=\"info-icon\"><i class=\"fas fa-info-circle\"></i></div>

$pintease

</div>

" > pinned.txt
