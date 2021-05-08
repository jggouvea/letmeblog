#!/bin/sh

source $(pwd | cut -d'/' -f1,2,3,4)/site.cfg

rm -f recent.txt 

for recent in $(find src/posts -type f -iname \*.md | sort -ur | head -n 6)
do 
entry="$(basename $recent .md).html"
title=$(grep "title: " $recent | cut -d'"' -f2)
plink="posts/$entry"
teaser=$(cat $recent | sed -e '1,/^$/d' | sed '/^$/,$d' | pandoc ) 
cover=$(grep "coverImage:" $recent | cut -d'"' -f2)
date=$(grep "date: " $recent | cut -d' ' -f2 | cut -d'"' -f2)
pdate=$(date -u --date=$date '+%d/%m/%Y')

if [ ! -z "$cover" ]; 
then 
coverpic="<figure class=\"thumb\"><img src=\"/images/$cover\" alt=\"post thumbnail\" /></figure>"
else
coverpic=""
fi


echo "

<div class="recent-posts">
## [$title]($plink)

$coverpic $teaser

</div>
" >> recent.txt
done
