#!/bin/sh

source scripts/site_vars.sh

for page in `find src/pages -type f -iname \*.md`
do
pandoc --to=html5 --from $panopts       $page  \
     --title-prefix="$site_id  ·  " --template templates/blog.html \
       -o     pages/"$(basename $page .md).html" \
       -V   sidebar="$(cat $pageside)" \
       -V    footer="$(cat $pagefoot)" \
      -V      textfont="$textfont" \
       -V      headfont="$headfont" \
       -V   site_id="$site_id" \
       -V site_desc="$site_desc" \
       -V    author="$author" \
       -V signature="$signature" \
       -V    updmsg="$updmsg" \
       -V    update="$update" \
       -V   baseurl=".." -V lang="pt"
done

echo "Static pages compiled successfully"
