#!/bin/sh

source $(pwd | cut -d'/' -f1,2,3,4)/site.cfg

find src/posts/ -name \*.md | sort > manifest.txt

for blogpost in `find src/posts -name \*.md | sort`; do 

    fdate=$(echo $blogpost | cut -d'/' -f3 | cut -d'-' -f1,2,3)
    pdate=$(date -u --date=$fdate '+%d/%m/%Y')
    slug=$(basename $blogpost .md)
	befo=$(grep -B 1 $blogpost manifest.txt | sed '2d' | sed 's/src//' | sed 's/md/html/')
	aftr=$(grep -A 1 $blogpost manifest.txt | sed '1d' | sed 's/src//' | sed 's/md/html/')
echo "Compiling $slug"

pandoc --to=html5 --from $panopts   \
       -o     posts/$slug".html" --toc --toc-depth=2 $blogpost \
    --title-prefix="$site_id · " \
	--template templates/blog.html \
	-V      befo="$befo" -V aftr="$aftr" \
	-V    site_id="$site_id" \
	-V  site_desc="$site_desc" \
	-V     author="$author" \
	-V  signature="$signature" \
	-V     updmsg="$updmsg" \
	-V     update="$update" \
	-V  published="$pdate" \
	-V  catprefix="$catprefix" \
	-V   catcount="$catcount" \
	-V  tagprefix="$tagprefix" \
	-V   tagcount="$tagcount" \
	-V  postcount="$postcount" \
	-V    archive="$archive" \
	-V    fonturl="$fonturl" \
	-V   textfont="$textfont" \
	-V   headfont="$headfont" \
	-V fontenctxt="$fontenctxt" \
	-V fontenchdr="$fontenchdr" \
	-V    baseurl="$baseurl" \
	-V       lang="pt"  &
done

for pid in $(jobs -p); do
    wait $pid
done

echo "Finished compilation of all post pages."
