#!/bin/sh

source $(pwd | cut -d'/' -f1,2,3,4)/site.cfg

for page in `find src/pages -type f -iname \*.md`
do
pandoc --to=html5 --from $panopts   \
       -o     pages/"$(basename $page .md).html" $page \
    --title-prefix="$site_id · " \
	--template templates/blog.html \
	-V    site_id="$site_id" \
	-V  site_desc="$site_desc" \
	-V     author="$author" \
	-V  signature="$signature" \
	-V     updmsg="$updmsg" \
	-V     update="$update" \
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
	-V       lang="pt"
done

echo "Static pages compiled successfully"
