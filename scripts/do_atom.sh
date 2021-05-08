#!/bin/sh

source $(pwd | cut -d'/' -f1,2,3,4)/site.cfg

echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<feed xmlns=\"http://www.w3.org/2005/Atom\">
<title>$site_id</title>
<link rel=\"alternate\" type=\"text/html\" 
	href=\"$baseurl\"/>
<link rel=\"self\" type=\"application/atom+xml\" 
	href=\"$baseurl/atom.xml\"/>
<id>$baseurl</id>
<subtitle>$site_desc.</subtitle>
<icon>$baseurl/favicon.ico</icon>
<accentColor>dd5500</accentColor>
<related layout=\"card\" target=\"browser\"/>
<updated>${update}T19:00:00-03:00</updated>
<author>
<name>José Geraldo Gouvêa</name>
<email>Lukas@lukasmurdock.com</email>
<uri>$baseurl</uri>
</author>
<generator>https://github.com/jggouvea/letmeblog</generator>
" > atom.xml
	
for md in `find src/posts -name \*.md | sort -ru | head -n 12`;
do
dateurl=$(date --date=`basename $md|cut -d'-' -f 1-3` '+%Y-%m-%d')
title=$(grep "title: " $md | cut -d'"' -f2)
linkurl=$(echo $md | sed 's/.md/.html/')
tagurl=$(echo $baseurl | cut -d'/' -f3)
upurl=$(date -r $md +%Y-%m-%dT%H:%M:%S)
category=$(grep "categories:" -A1 $md | sed '1d' | cut -d'"' -f2)
teaser=$(cat $md | sed -e '1,/^$/d' | sed '/^$/,$d' | pandoc)

echo "<entry>
  <title>$title</title>
   <id>tag:$tagurl,$dateurl:/booklist/map-and-territory</id>
    <updated>$upurl</updated>
    <content type=\"html\" xml:lang=\"en\" xml:base=\"$baseurl\">
    <![CDATA[<a href=\"$baseurl/$linkurl\"><h1>$title</h1></a> ]]>
	$teaser
    </content>
    <category term=\"$category\"/>
        <published>$dateurl</published>
    </entry>" >> atom.xml

printf "\n" >> atom.xml
done

echo "</feed>" >> atom.xml
