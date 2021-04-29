#!/bin/sh
source scripts/site_vars.sh

echo "Now we must compile the posts themselves,
This will take long time."

for blogpost in `find src/posts -type f -iname \*.md`; do 

    fdate=$(echo $blogpost | cut -d'/' -f3 | cut -d'-' -f1,2,3)
    pdate=$(date -u --date=$fdate '+%d/%m/%Y')
    slug=$(basename $blogpost .md)
    
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
       -V   baseurl=".." -V lang="pt"  &
done

for pid in $(jobs -p); do
    wait $pid
done

find src/posts/ -type f -iname \*.md | sort -r > manifest.txt
mv manifest.txt src/posts/manifest.txt

echo "Finished compilation of all post pages."
