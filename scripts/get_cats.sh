#!/bin/sh

rm -f catlist.txt

for post in `find src/posts -type f -iname \*.md`
do
pandoc --template=templates/metadata.tpl $post \
	| jq -r '.categories|@tsv' >> taglist.txt
done

tr '\t' "\n" < catlist.txt | sort | uniq > _catlist
mv _catlist catlist.txt
