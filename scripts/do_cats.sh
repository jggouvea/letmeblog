#!/bin/sh

source $(pwd | cut -d'/' -f1,2,3,4)/site.cfg

if [ -z $catprefix ]; then
catprefix="categories"
fi

if [ -z $tagprefix ]; then
tagprefix="tags" 
fi


echo "Will create and populate category pages."

for category in `cat catlist.txt`
do
ind="$catprefix/$category/index.txt"
tmp="$catprefix/$category/_posts.txt"
rm -rf $catprefix/$category
mkdir -p $catprefix/$category

echo "---
title: Artigos da categoria \"$category\"
---
<div class=\"postlist\">
" > $ind

echo "Grepping each post by category."

grep -le "  - \"$category\"" src/posts/*.md | sort -r > $tmp

echo "Listing posts in categories."

for blogpost in `cat $tmp`
do
    fdate=$(echo $blogpost | cut -d'/' -f3 | cut -d'-' -f1,2,3)
    plink=$(echo $(basename $blogpost .md).html)
    pdate=$(date -u --date=$fdate '+%d/%m/%Y')
    title=$(grep -e "title: \"" $blogpost | cut -d'"' -f2)
    pyear=$(date -u --date=$fdate '+%Y')

echo "- <span class=\"pdate\">$pdate</span> - [$title](/posts/$plink)" >> $ind
echo "Encontrado \"$title\", de $pdate, categoria \"$category\"."  
done
echo "</div>" >> $ind

echo "Compiling category index pages"

pandoc --to=html5 --from $panopts  $ind   \
       -o "$catprefix/$category/$(basename $ind .txt).html" \
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
	-V  tagprefix="$tagprefix" \
	-V   tagcount="$tagcount" \
	-V  postcount="$postcount" \
	-V    archive="$archive" \
	-V    fonturl="$fonturl" \
	-V   textfont="$textfont" \
	-V   headfont="$headfont" \
	-V fontenctxt="$fontenctxt" \
	-V fontenchdr="$fontenchdr" \
	-V    baseurl="$baseurl" \
	-V       lang="pt"
done

echo "---
title: \"Lista de categorias\"
---

Categorias procuram classificar o conteúdo quanto ao gênero
textual e à intenção da escrita. As categorias do \"Letras Elétricas\"
são herdadas do antigo blog em WordPress e serão gradualmente 
alteradas, à medida que os posts forem editados.

|
|:---:|:---:|:---:|" > $catprefix/index.txt

cp catlist.txt $catprefix/_catlist.txt 

paste -d' ' catlist.txt $catprefix/_catlist.txt > $catprefix/_index.txt
sed -i  's/ $//g' $catprefix/_index.txt
tr -s " " < $catprefix/_index.txt > $catprefix/__index.txt
mv $catprefix/__index.txt $catprefix/_index.txt
sed -i 's/$/ |/g' $catprefix/_index.txt
cat $catprefix/_index.txt | tr \  \\n | column -x -c 150 > $catprefix/__index.txt
mv $catprefix/__index.txt $catprefix/_index.txt
sed -i 's/\t/ /g' $catprefix/_index.txt
sed -i 's/  / /g' $catprefix/_index.txt
sed -i 's/^/| /g' $catprefix/_index.txt
sed -i 's/ |/\/index.html) |/g' $catprefix/_index.txt
sed -i 's/| /| [/g' $catprefix/_index.txt
sed -i 's/ /] /g' $catprefix/_index.txt
sed -i 's/|]/|/g' $catprefix/_index.txt
sed -i 's/] /](/g' $catprefix/_index.txt
sed -i 's/](|/ |/g' $catprefix/_index.txt

cat $catprefix/_index.txt >> $catprefix/index.txt
rm $catprefix/_index.txt

echo "

|
|:----:|:----:|
| [Retornar aos posts](/posts/index.html) | [Retornar à home](/index.html) |
">> $catprefix/index.txt

pandoc --to=html5 --from $panopts  $catprefix/index.txt   \
    -o $catprefix/index.html \
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
	-V  tagprefix="$tagprefix" \
	-V   tagcount="$tagcount" \
	-V  postcount="$postcount" \
	-V    archive="$archive" \
	-V    fonturl="$fonturl" \
	-V   textfont="$textfont" \
	-V   headfont="$headfont" \
	-V fontenctxt="$fontenctxt" \
	-V fontenchdr="$fontenchdr" \
	-V    baseurl="$baseurl" \
	-V       lang="pt"

sed -z 's/<table>/<table class=\"back\">/2' $catprefix/index.html > posts.htm

mv posts.htm $catprefix/index.html
     
echo "Categories index prepared"
