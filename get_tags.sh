#!/bin/sh

#rm -f taglist.txt

#for post in posts/*-*.md
#do
#pandoc --template=templates/metadata.tpl  $post | jq -r '.tags|@tsv' >> taglist.txt
#done

tr '\t' "\n" < taglist.txt | sort | uniq > _taglist
mv _taglist taglist.txt
