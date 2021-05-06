#!/bin/sh

source scripts/site_vars.sh

pandoc --to=html5 --from $panopts src/index.md pinned.txt recent.txt \
       -o index.html --standalone \
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
