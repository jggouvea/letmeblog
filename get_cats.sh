#!/bin/sh

rm -f taglist.txt

for post in posts/*-*.md
do
pandoc --template=templates/metadata.tpl  $post | jq -r '.categories|@tsv' >> taglist.txt
done

tr '\t' "\n" < catlist.txt | sort | uniq > _catlist
mv _catlist catlist.txt
