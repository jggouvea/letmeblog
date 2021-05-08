#!/bin/sh

source $(pwd | cut -d'/' -f1,2,3,4)/site.cfg

temp=_index.txt
rm -f $temp

echo "---
title: \"Arquivo de postagens\"
---

<p class=\"intro\">Esta é a lista completa dos artigos escritos para o 
\"Letras Elétricas\" desde 2010, incluindo uma lista parcial de artigos
anteriormente escritos para outros sites mantidos por mim.</p>" > $temp

for blogpost in $(find src/posts -type f -iname \*.md | sort -r); 
do
	fdate=$(echo $blogpost | cut -d'/' -f3 | cut -d'-' -f1,2,3)
	pyear=$(date -u --date=$fdate '+%Y')
	pdate=$(date -u --date=$fdate '+%d/%m/%Y')
 	plink=$(echo $(basename $blogpost .md).html)
 	title=$(grep -e "title:" $blogpost | cut -d':' -f2 | cut -d'"' -f2)
 	
 if [ "$pyear" != "$this_year" ]; then
    echo -e "\n## $pyear\n" >> $temp
 fi
 this_year=$pyear
 echo "- <b class=\"pdate\">$pdate<b> - [$title]($plink)">>$temp
done

pandoc --to=html5 --from $panopts         \
       -o     posts/"$archive".html   $temp \
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
rm -f $temp
