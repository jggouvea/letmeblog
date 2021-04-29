#!/bin/sh
source scripts/site_vars.sh

page="src/pages/livros.md"
source="categorias/obras/_posts.txt"
books="pages/livros.txt"

rm -f $books
for post in `cat $source`;
do
entry="$(basename $post .md).html"
title=$(grep "title: " $post | cut -d'"' -f2)
plink="/posts/$entry"
teaser=$(cat $post | sed -e '1,/^$/d' | sed '/^$/,$d') 
cover=$(grep "coverImage:" $post | cut -d'"' -f2)
echo "

## [$title]($plink)

<figure class=\"thumb\"><img src=\"/images/$cover\" 
alt=\"thumbnail\" /></figure>
$teaser
" >> $books
done

pandoc --to=html5 --from $panopts  $page $books   \
     --title-prefix="$site_id · " --template templates/blog.html \
       -o pages/livros.html \
       -V   sidebar="$(cat $pageside)" \
       -V    footer="$(cat $pagefoot)" \
      -V      text="$text" \
       -V      head="$head" \
       -V   site_id="$site_id" \
       -V site_desc="$site_desc" \
       -V    author="$author" \
       -V signature="$signature" \
       -V    updmsg="$updmsg" \
       -V    update="$update" \
       -V   baseurl=".." -V lang="pt"

echo "Book list page updated..."
