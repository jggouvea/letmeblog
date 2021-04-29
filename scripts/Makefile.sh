#!/bin/sh

# Just FYI, these are the linux commands necessary to compile a blog using
# this script (don't mind the versions, the script will probably run fine
# with slightly older versions.

# Coreutils (version 8.32-1)  === from which we use the following commands:
# basename, cat, date, echo, export, head, ls, rm, rmdir, sort, tail, uniq, wc

# GNU grep (version 3.6-1)

# JQ (version 1.6-4)

# Pandoc (version 2.13-3) <==== Goal: find a way to replace this with a lighter
#                                     markdown processor, if there is any
#                                     which can do variables and templates

# SED (version 4.8-1)

source <site_vars.sh>

# This script should compile the blog posts homepage and the 
# blog archives per year.

echo "32. Time for a neat blog homepage."

echo "---
title: \"Página de índices\"
---


|:--------------:|:-------------:|:---------------------:|
| [artigos por categoria](/categorias/index.html) | \
[artigos por assunto](/assuntos/index.html) | [lista completa](arquivo.html) |
" > src/posts/index.txt

echo "
## Recentes
" >> src/posts/index.txt

for blogpost in $(find src/posts/ -name "*.md" | sort -r | head -n 10); 
do
fdate=$(echo $blogpost | cut -d'/' -f2 | cut -d'-' -f1,2,3)
pyear=$(date -u --date=$fdate '+%Y')
pdate=$(date -u --date=$fdate '+%d/%m/%Y')
plink=$(echo $(basename $blogpost .md).html)
title=$(grep -e "title: " $blogpost | cut -d':' -f2,3 | cut -d'"' -f2)
echo "- <b class=\"pdate\">$pdate</b> - [$title](/posts/$plink)" >> src/posts/index.txt
done

rm -f years.txt
rm -rf arquivos/*

echo "33. Finished posts index."

seq -s'x' $first_year $current_year | sed 's/x/\n/g' >> years.txt


for Year in `cat years.txt`;
do
ind="arquivos/$Year/index.txt"
tmp="arquivos/$Year/posts.txt"
rm -rf $ind $tmp
rm -rf arquivos/$Year
mkdir -p arquivos/$Year

echo "---
title: Artigos publicados em $Year
---

" > $ind

for blogpost in $(find src/posts/ -iname $Year-\*.md | sort -r);
do
    fdate=$(echo $blogpost | cut -d'/' -f2 | cut -d'-' -f1,2,3)
    plink=$(echo $(basename $blogpost .md).html)
    pdate=$(date -u --date=$fdate '+%d/%m')
    title=$(grep -e "title: \"" $blogpost | cut -d'"' -f2)
    pyear=$(date -u --date=$fdate '+%Y')

  echo "- <span class=\"pdate\">$pdate</span> - [$title](/posts/$plink)" >> $ind
  echo "Encontrado \"$title\", de $pyear."  
done

pandoc --to=html5 --from $panopts       $ind  \
     --title-prefix="$site_id  · "  --template templates/blog.html \
       -o     arquivos/$Year/index.html   \
       -V   sidebar="$(cat $pageside)" \
       -V    footer="$(cat $pagefoot)" \
      -V      text="$text" \
      -V head="$head" \
       -V   site_id="$site_id" \
       -V site_desc="$site_desc" \
       -V    author="$author" \
       -V signature="$signature" \
       -V    updmsg="$updmsg" \
       -V    update="$update" \
       -V   baseurl="$baseurl" -V lang="pt"
done

echo "---
title: \"Arquivo do blog\"
---

<p class=\"intro\">Postagens por ano</p>" >> arquivos/index.txt

echo "
|:-------:|:-------:|:-------:|" > tab.txt

find arquivos/* -maxdepth 1 -type d  | cut -d'/' -f2  | \
sed 's/\.//g' | sort -r | column -x -c 25 | sed 's/^/| /g' | \
sed 's/\t/ | /g' | sed 's/$/ |/g' >> tab.txt

cat tab.txt >> arquivos/index.txt

pandoc --to=html5 --from $panopts       arquivos/index.txt  \
     --title-prefix="$site_id  · "  --template templates/blog.html \
       -o     arquivos/index.html   \
       -V   sidebar="$(cat $pageside)" \
       -V    footer="$(cat $pagefoot)" \
      -V      text="$text" \
       -V      head="$head" \
       -V   site_id="$site_id" \
       -V site_desc="$site_desc" \
       -V    author="$author" \
       -V signature="$signature" \
       -V    updmsg="$updmsg" \
       -V    update="$update" \
       -V   baseurl="$baseurl" -V lang="pt"

cat tab.txt >> src/posts/index.txt

pandoc --to=html5 --from $panopts       src/posts/index.txt  \
     --title-prefix="$site_id  · "  --template templates/blog.html \
       -o     posts/index.html   \
       -V   sidebar="$(cat $pageside)" \
       -V    footer="$(cat $pagefoot)" \
      -V      text="$text" \
       -V      head="$head" \
       -V   site_id="$site_id" \
       -V site_desc="$site_desc" \
       -V    author="$author" \
       -V signature="$signature" \
       -V    updmsg="$updmsg" \
       -V    update="$update" \
       -V   baseurl="$baseurl" -V lang="pt"

echo
