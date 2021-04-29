#!/bin/sh
source scripts/site_vars.sh

feedbegin=`cat <<EOF
<?xml version="1.0" encoding="utf-8"?>

<feed xmlns="http://www.w3.org/2005/Atom">
  <id>$baseurl/atom.xml</id>
	<title>$site_id</title>
	<link href="/atom.xml" rel="self" />
	<link href="/" />
	<updated>$timestamp</updated>
EOF
`

echo "$feedbegin" > atom.xml
printf "\n" >> atom.xml

for post in \
$(find src/posts -type f -iname \*.md | sort -ur | head -n 20); do
  date=$(date -u --date=$(basename $post | cut -d'-' -f 1-3) '+%Y-%m-%d')
  title=$(grep "title: " $post | cut -d'"' -f2)
  link="$(echo $post | sed 's/.md/.html/g')"
  head -n 15 $post | pandoc -f markdown -t html5 \
    --template templates/atom.xml \
    -V link=$link \
    -V timestamp="${date}T12:00:00Z" >> atom.xml 
  printf "\n" >> atom.xml
done

echo "</feed>" >> atom.xml
