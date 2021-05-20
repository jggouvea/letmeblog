#!/bin/sh

source $(pwd | cut -d'/' -f1,2,3,4)/site.cfg

pandoc --to=html5 --from $panopts  \
    -o busca.php -s busca.md \
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
	-V       lang="pt"  \
--metadata  title="Procurar nos posts"
       
cline=$(cat -n busca.php  | grep -n main-content | cut -d':' -f1)
head -n $cline busca.php > /tmp/top.txt
eline=$(cat -n busca.php  | grep -n id=\"footer\" | cut -d':' -f1)
tail -n +$eline busca.php > /tmp/end.txt
echo "</div></div>" > /tmp/div.txt
topscr="templates/top.php"
endscr="templates/end.php"

cat /tmp/top.txt "$topscr" busca.md "$endscr" /tmp/div.txt /tmp/end.txt > busca.php
rm /tmp/*.txt

sed -i '/\/head/i <link rel="stylesheet" href="\/search.css" \/>' busca.php

echo "Search page provided"
