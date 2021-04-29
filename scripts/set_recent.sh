#!/bin/sh

source scripts/site_vars.sh

rm -f recent.txt 

for rec in $(find src/posts -type f -iname \*.md | sort -ur | head -n 6)
do 
entry="$(basename $rec .md).html"
title=$(grep "title: " $rec | cut -d'"' -f2)
plink="posts/$entry"
teaser=$(cat $rec | sed -e '1,/^$/d' | sed '/^$/,$d' | pandoc ) 
cover=$(grep "coverImage:" $rec | cut -d'"' -f2)
date=$(grep "date: " $rec | cut -d' ' -f2 | cut -d'"' -f2)
pdate=$(date -u --date=$date '+%d/%m/%Y')

if [ ! -z "$cover" ]; 
then 
coverpic='<figure class="thumb"><img src="/images/$cover" /></figure>'
else
coverpic=""
fi


echo "

<div class=\"recent-posts\">
## [$title]($plink)

$coverpic $teaser

</div>
" >> recent.txt
done
