#!/bin/sh

source $(pwd | cut -d'/' -f1,2,3,4)/site.cfg

pandoc --to=html5 --from $panopts  \
    -o index.html -s src/index.md pinned.txt recent.txt \
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
	-V  postcount="$postcount" \
	-V  tagprefix="$tagprefix" \
	-V   tagcount="$tagcount" \
	-V    archive="$archive" \
	-V    fonturl="$fonturl" \
	-V   textfont="$textfont" \
	-V   headfont="$headfont" \
	-V fontenctxt="$fontenctxt" \
	-V fontenchdr="$fontenchdr" \
	-V    baseurl="$baseurl" \
	-V       lang="pt"
       
echo "Homepage compiled ..."
