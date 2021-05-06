#!/bin/sh
source scripts/site_vars.sh

echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<rss version=\"2.0\">
<channel>
<title>$site_id</title>
<link>$baseurl</link>
<description>$site_desc.</description>
" > rss.xml
	
for md in `find src/posts -name \*.md | sort -ru | head -n 12`;
do
dateurl=$(date --date=`basename $md|cut -d'-' -f 1-3` '+%Y-%m-%d')
title=$(grep "title: " $md | cut -d'"' -f2)
linkurl=$(echo $md | sed 's/.md/.html/' | cut -d'/' -f2,3)
tagurl=$(echo $baseurl | cut -d'/' -f3)
upurl=$(date -r $md +%Y-%m-%dT%H:%M:%S)
category=$(grep "categories:" -A1 $md | sed '1d' | cut -d'"' -f2)
teaser=$(cat $md | sed -e '1,/^$/d' | sed '/^$/,$d' | pandoc)

echo "<item>
  <title>$title</title>
<link>$baseurl/$linkurl</link>
<description>
	$teaser
    </description>
    </item>" >> rss.xml

printf "\n" >> rss.xml
done

echo "</channel>

</rss>" >> rss.xml
