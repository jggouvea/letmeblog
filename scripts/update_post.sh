#!/bin/sh

source $(pwd | cut -d'/' -f1,2,3,4)/site.cfg

blogpost=$1

befo=$(grep -B 1 $blogpost manifest.txt | sed '2d' | sed 's/src//' | sed 's/md/html/')
aftr=$(grep -A 1 $blogpost manifest.txt | sed '1d' | sed 's/src//' | sed 's/md/html/')
fdate=$(echo $blogpost | cut -d'/' -f3 | cut -d'-' -f1,2,3)
pdate=$(date -u --date=$fdate '+%d/%m/%Y')
slug=posts/$(basename $blogpost .md)
plink=$(echo $(basename $blogpost .md).html)
title=$(grep -e "title: \"" $blogpost | cut -d'"' -f2)
pyear=$(date -u --date=$fdate '+%Y')

pandoc --to=html5 --from $panopts  $blogpost \
	-o     $slug".html" --toc-depth=3 \
    --title-prefix="$site_id · "  --toc \
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
	-V       lang="pt"
