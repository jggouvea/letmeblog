#! /usr/bin/env bash

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

# ZSH (version 5.8)

# Variables to be reused throughout the compilation, till the end.

# Basics
baseurl="http://localhost" 
#baseurl="https://www.letraseletricas.blog.br"
site_id="Letras Elétricas"

# Replace catprefix and tagprefix with the correct names for your locale.
catprefix="categorias"
tagprefix="assuntos"

# Unvariable variables... Don't mess with this part of the script.
# These are some failsafes.
current_year=$(date | cut -d' ' -f4)
if [ -z $catprefix ]; then
catprefix="categories"
fi

if [ -z $tagprefix ]; then
tagprefix="tags" 
fi

# We are going to extract some information that will be used in the templates:

# a) how big is my blog directory? how many posts in there?
postcount=$(ls posts/*-*.md | wc -l)

# b) how many tags do we have?
tagcount=$(cat taglist.txt | wc -l)

# c) how many categories?
catcount=$(cat catlist.txt | wc -l)

# d) when did I post for the last time?
last_post=$(ls posts/$current_year-*.md | sort -r | head -n 1 | cut -d'/' -f2 | cut -d'-' -f1,2,3)
update=$(date -u --date=$last_post '+%d %b %Y')

# The templates
# We begin with a raw sidebar, where we have marked the places for the 
# information variables above. We copy it to another file (which Pandoc
# will actually use) and perform sed replacements in the copied file,
# preserving the original for a future run.

cp templates/rawsidebar.txt templates/sidebar.txt

sed -i "s/POSTCOUNT/$postcount/g" templates/sidebar.txt
sed -i "s/TAGCOUNT/$tagcount/g" templates/sidebar.txt
sed -i "s/CATCOUNT/$catcount/g" templates/sidebar.txt
sed -i "s/UPDATE/$update/g" templates/sidebar.txt

pagehead="templates/masthead.txt"
pageside="templates/sidebar.txt"
pagefoot="templates/footer.txt"

# Google Fonts (if compound name, do use the plus sign to join)
textfont="DM+Sans"
monofont="DM+Mono"
logofont="Fraunces"

# In the beginning, there was a homepage
pandoc --to=html5 --from markdown+smart+yaml_metadata_block        \
       --title-prefix="$site_id · " --template templates/page.html \
       -V masthead="$(cat $pagehead)" \
       -V  sidebar="$(cat $pageside)" \
       -V   footer="$(cat $pagefoot)" \
       -V textstyle="$textfont:ital,wght@0,400;0,700;1,400;1,700" \
       -V headstyle="$logofont:ital,wght@0,400;0,700;0,900;1,400;1,700" \
       -V monostyle="$monofont" \
       -V baseurl="$baseurl" \
       -o index.html --standalone index.md recent.md pinned.md
  
# Next we build a post index
temp="_index.md"
rm -f $temp
export HEADER=`cat <<EOF
---
title: Arquivo de postagens
---

<p class="intro">Esta é a lista completa dos artigos escritos para o 
"Letras Elétricas" desde 2010, incluindo uma lista parcial de artigos
anteriormente escritos para outros sites mantidos por mim.</p>

EOF
`

echo "$HEADER" > $temp

for blogpost in $(ls posts/*.md | sort -r); 
do
	fdate=$(echo $blogpost | cut -d'/' -f2 | cut -d'-' -f1,2,3)
	pyear=$(date -u --date=$fdate '+%Y')
	pdate=$(date -u --date=$fdate '+%d %b %Y')
 	plink=$(echo $(basename $blogpost .md).html)
 	title=$(grep -e "title:" $blogpost | cut -d':' -f2 | cut -d'"' -f2)
 	
  if [ $pyear != $current_year ]; then
    echo -e "\n## $pyear\n" >> $temp
  fi
  current_year=$pyear
  echo "- <span class=\"pdate\">$pdate</span> - [$title]($plink)" >> $temp
done

pandoc --to=html5 --from markdown+smart+yaml_metadata_block $temp  \
       --title-prefix="$site_id · " --template templates/page.html \
       -o "posts/index.html"   \
       -V masthead="$(cat $pagehead)" \
       -V  sidebar="$(cat $pageside)" \
       -V   footer="$(cat $pagefoot)" \
       -V textstyle="$textfont:ital,wght@0,400;0,700;1,400;1,700" \
       -V headstyle="$logofont:ital,wght@0,400;0,700;0,900;1,400;1,700" \
       -V monostyle="$monofont" \
       -V baseurl="$baseurl" \
       -V year="$(date -u +%Y)"

# I have not yet figured out why Jilles included this "year"
# variable at this point, but I am keeping it none the less,
# so I don't have to do more than I already did.

# cleaning the clutter
rm -f $temp

# Now we compile the static pages...
for page in pages/*.md; do
pandoc --to=html5 --from markdown+smart+yaml_metadata_block $page  \
       --title-prefix="$site_id · " --template templates/page.html \
       -o pages/"$(basename $page .md).html" \
       -V masthead="$(cat $pagehead)" \
       -V  sidebar="$(cat $pageside)" \
       -V   footer="$(cat $pagefoot)" \
       -V textstyle="$textfont:ital,wght@0,400;0,700;1,400;1,700" \
       -V headstyle="$logofont:ital,wght@0,400;0,700;0,900;1,400;1,700" \
       -V monostyle="$monofont" \
       -V baseurl="$baseurl" \
       -V year="$(date -u +%Y)"
done

# With the static pages ready, we must create and populate the
# Category pages.
for category in `cat catlist.txt`
do
ind="$catprefix/$category/index.txt"
tmp="$catprefix/$category/_posts.txt"
rm -rf $catprefix/$category
mkdir -p $catprefix/$category

echo "Limpeza terminada..."

echo "---
title: Artigos da categoria \"$category\"
---

" > $ind

echo "criada intro..."

grep -l -e "  - \"$category\"" posts/*.md | sort -r > $tmp

echo "lista de postagens..."

for blogpost in `cat $tmp`
do
    fdate=$(echo $blogpost | cut -d'/' -f2 | cut -d'-' -f1,2,3)
    plink=$(echo $(basename $blogpost .md).html)
    pdate=$(date -u --date=$fdate '+%d %b %Y')
    title=$(grep -e "title: \"" $blogpost | cut -d'"' -f2)
    pyear=$(date -u --date=$fdate '+%Y')
 	
  if [ $pyear != $current_year ]; then
    echo -e "\n## $pyear\n" >> $temp
  fi
  current_year=$pyear

  echo "- <span class=\"pdate\">$pdate</span> - [$title](../../posts/$plink)" >> $ind
  echo "Encontrado post \"$title\", de $pdate, 
   arquivado na categoria \"$category\"."  
done

pandoc --to=html5 --from markdown+smart+yaml_metadata_block $ind   \
       --title-prefix="$site_id · " --template templates/page.html \
       -o "$catprefix/$category/$(basename $ind .txt).html" \
       -V masthead="$(cat $pagehead)" \
       -V  sidebar="$(cat $pageside)" \
       -V   footer="$(cat $pagefoot)" \
       -V textstyle="$textfont:ital,wght@0,400;0,700;1,400;1,700" \
       -V headstyle="$logofont:ital,wght@0,400;0,700;0,900;1,400;1,700" \
       -V monostyle="$monofont" \
       -V baseurl="$baseurl" \    
       -V year="$(date -u +%Y)"
done

# Done with categories, let's build the tag pages

for tag in `cat taglist.txt`
do
ind="$tagprefix/$tag/index.txt"
tmp="$tagprefix/$tag/_posts.txt"
rm -rf $tagprefix/$tag/*.txt
mkdir -p $tagprefix/$tag/

echo "Limpeza terminada..."

echo "---
title: Postagens sobre \"$tag\"
---

" > $ind

echo "criada intro..."

grep -l -e "  - \"$category\"" posts/*.md | sort -r > $tmp

echo "lista de $tagprefix..."

for blogpost in `cat $tmp`
do
    fdate=$(echo $blogpost | cut -d'/' -f2 | cut -d'-' -f1,2,3)
    plink=$(echo $(basename $blogpost .md).html)
    pdate=$(date -u --date=$fdate '+%d %b %Y')
    title=$(grep -e "title: \"" $blogpost | cut -d'"' -f2)
    pyear=$(date -u --date=$fdate '+%Y')

  if [ $pyear != $current_year ]; then
    echo -e "\n## $pyear\n" >> $temp
  fi
  current_year=$pyear

  echo "- <span class=\"pdate\">$pdate</span> - [$title](../../posts/$plink)" >> $ind
  echo "Encontrado post \"$title\", de $pdate, 
   marcado no assunto \"$tag\"."  
done

pandoc --to=html5 --from markdown+smart+yaml_metadata_block $ind   \
       --title-prefix="$site_id · " --template templates/page.html \
       -o "$tagprefix/$tag/$(basename $ind .txt).html" \
       -V masthead="$(cat $pagehead)" \
       -V  sidebar="$(cat $pageside)" \
       -V   footer="$(cat $pagefoot)" \
       -V textstyle="$textfont:ital,wght@0,400;0,700;1,400;1,700" \
       -V headstyle="$logofont:ital,wght@0,400;0,700;0,900;1,400;1,700" \
       -V monostyle="$monofont" \
       -V baseurl="$baseurl" \ 
       -V year="$(date -u +%Y)"
done

# Time now to compile the posts themselves

for blogpost in $(ls posts/*-*.md); do 

    fdate=$(echo $blogpost | cut -d'/' -f2 | cut -d'-' -f1,2,3)
    pdate=$(date -u --date=$fdate '+%d %b %Y')

pandoc --to=html5 --from markdown+smart+yaml_metadata_block $blogpost \
       --title-prefix="$site_id · " --template templates/article.html \
       -o posts/"$(basename $blogpost .md).html" \
       -V masthead="$(cat $pagehead)" \
       -V  sidebar="$(cat $pageside)" \
       -V   footer="$(cat $pagefoot)" \
       -V textstyle="$textfont:ital,wght@0,400;0,700;1,400;1,700" \
       -V headstyle="$logofont:ital,wght@0,400;0,700;0,900;1,400;1,700" \
       -V monostyle="$monofont" \
       -V baseurl="$baseurl" \   
  	   -V year="$(date -u +%Y)" &
done
for pid in $(jobs -p); do
    wait $pid
done


# Make the sitemap if everything above was OK.
sitemap="sitemap.xml"
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

function url() {
  echo "<url><loc>${baseurl}/$1<loc><lastmod>$timestamp</lastmod></url>"
}

robots=`cat <<EOF
User-agent: *
Allow: *
Sitemap: $baseurl/sitemap.xml
EOF
`
echo "$robots" > robots.txt

header=`cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
EOF
` 
echo "$header" > $sitemap

for page in $(find pages -name "*.html" | sed -e 's/pages\///'); do
  echo $(url $page) >> $sitemap
done

for post in $(find posts -name "*.html" | sed -e 's/posts\///'); do
  echo $(url $post) >> $sitemap
done

for pcat in $(find categories -name "*.html" | sed -e 's/categories\///'); do
  echo $(url $pcat) >> $sitemap
done

for ptag in $(find tags -name "*.html" | sed -e 's/tags\///'); do
  echo $(url $ptag) >> $sitemap
done

printf "</urlset>\n" >> $sitemap

# Make the atom feed

