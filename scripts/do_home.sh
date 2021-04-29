#!/bin/sh

source scripts/site_vars.sh

pandoc --to=html5 --from $panopts       \
     --title-prefix="$site_id · " --template templates/blog.html \
       -V   sidebar="$(cat $pageside)" \
       -V    footer="$(cat $pagefoot)" \
       -V  textfont="$textfont" \
       -V  headfont="$headfont" \
       -V   site_id="$site_id" \
       -V site_desc="$site_desc" \
       -V    author="$author" \
       -V signature="$signature" \
       -V    updmsg="$updmsg" \
       -V    update="$update" \
       -V lang="pt" \
       -o index.html --standalone src/index.md pinned.txt recent.txt 
       
echo "Homepage compiled ..."
