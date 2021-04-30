#!/bin/sh
source scripts/site_vars.sh

find src/posts/ -name \*.md | sort > manifest.txt

for blogpost in `find src/posts -name \*.md`; do 

    fdate=$(echo $blogpost | cut -d'/' -f3 | cut -d'-' -f1,2,3)
    pdate=$(date -u --date=$fdate '+%d/%m/%Y')
    slug=$(basename $blogpost .md)
	befo=$(grep -B 1 $blogpost manifest.txt | sed '2d' | sed 's/src//' | sed 's/md/html/')
	aftr=$(grep -A 1 $blogpost manifest.txt | sed '1d' | sed 's/src//' | sed 's/md/html/')
echo "Compiling $slug"

pandoc --to=html5 --from $panopts  $blogpost \
     --title-prefix="$site_id · " --template templates/blog.html \
       -o     posts/$slug".html" \
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
       -V published="$pdate" \
	   -V    before="$befo" \
	   -V     after="$aftr" \
       -V   baseurl=".." -V lang="pt"  &
done

for pid in $(jobs -p); do
    wait $pid
done

echo "Finished compilation of all post pages."
