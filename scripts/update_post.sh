#!/bin/sh
source scripts/site_vars.sh

blogpost=$1

post=$(echo $blogpost | cut -d'.' -f1 | sed 's/$/.md/g')
fdate=$(echo $blogpost | cut -d'/' -f3 | cut -d'-' -f1,2,3)
pdate=$(date -u --date=$fdate '+%d/%m/%Y')
slug=posts/$(basename $blogpost .md)
plink=$(echo $(basename $blogpost .md).html)
title=$(grep -e "title: \"" $blogpost | cut -d'"' -f2)
pyear=$(date -u --date=$fdate '+%Y')

pandoc --to=html5 --from $panopts  $blogpost \
	-o     $slug".html" \
    --title-prefix="$site_id · " \
	--template templates/blog.html \
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
