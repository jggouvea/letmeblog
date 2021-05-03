#!/bin/sh

rm -f taglist.txt

for post in `find src/posts -type f -name \*.md`
do
pandoc --template templates/metadata.tpl  $post | jq -r '.tags|@tsv' >> taglist.txt
done

tr '\t' "\n" < taglist.txt | sort | uniq > _taglist
mv _taglist taglist.txt
