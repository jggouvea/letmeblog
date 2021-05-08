#!/bin/sh

source $(pwd | cut -d'/' -f1,2,3,4)/site.cfg

echo "Will build index pages for the tags"

for tag in `cat taglist.txt`
do
ind="$tagprefix/$tag/index.txt"
tmp="$tagprefix/$tag/_posts.txt"
rm -f "$tagprefix"/"$tag"/*
mkdir -p "$tagprefix"/"$tag"

echo "---
title: Postagens sobre \"$tag\"
---
<div class=\"postlist\">
" > $ind

grep -le "  - \"$tag\"" src/posts/*.md | sort -r > $tmp

echo "Grepping posts for tags and populating tag index pages."

for blogpost in `cat $tmp`
do
    fdate=$(echo $blogpost | cut -d'/' -f3 | cut -d'-' -f1,2,3)
    plink=$(echo $(basename $blogpost .md).html)
    pdate=$(date -u --date=$fdate '+%d/%m/%Y')
    title=$(grep -e "title: \"" $blogpost | cut -d'"' -f2)
    pyear=$(date -u --date=$fdate '+%Y')

  echo "- <span class=\"pdate\">$pdate</span> - 
[$title](/posts/$plink)" >> $ind
done

echo "</div>" >> $ind
echo "Compiling tag index page."

pandoc --to=html5 --from $panopts     \
       -o "$tagprefix/$tag/$(basename $ind .txt).html" $ind \
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

echo "Finished populating tags,
Will now create the tags index."

echo "---
title: \"Lista de assuntos\"
---

Assuntos (_tags_) classificam as postagens pelo conteúdo e pelo
estilo, em vez do gênero textual. Na maioria dos blogs, as 
_tags_ são usadas somente para classificar os artigos a fim de
gerar sugestões de páginas afins.

As _tags_ aqui indicadas são as que haviam sido geradas pelo
antigo site em WordPress. Infelizmente, muitas destas
estão repetidas devido a pequenos erros de digitação. Esta 
situação foi causada pela interface imperfeita do WordPress para
manipular categorias e tags, que muito dificultava a consulta 
das existentes.

Além disso, por um certo tempo eu mantive instalado no meu blog
o plug-in \"Commenters Can Add Tags\", que foi abusado pelos
visitantes para criar muitas _tags_ absurdas ou até obscenas.
Com alguma dificuldade eu consegui remover a maioria destas
antes de fazer o _upload_ da nova versão.

|
|:---:|:---:|:---:|" > $tagprefix/index.txt

cp taglist.txt $tagprefix/_taglist.txt 

paste -d' ' taglist.txt $tagprefix/_taglist.txt > $tagprefix/_index.txt
sed -i  's/ $//g' $tagprefix/_index.txt
tr -s " " < $tagprefix/_index.txt > $tagprefix/__index.txt
mv $tagprefix/__index.txt $tagprefix/_index.txt
sed -i 's/$/ |/g' $tagprefix/_index.txt
cat $tagprefix/_index.txt | tr \  \\n | column -x -c 230 > $tagprefix/__index.txt
mv $tagprefix/__index.txt $tagprefix/_index.txt
tr -s "\t" < $tagprefix/_index.txt > $tagprefix/__index.txt 
mv $tagprefix/__index.txt $tagprefix/_index.txt
sed -i 's/\t/ /g' $tagprefix/_index.txt
sed -i 's/  / /g' $tagprefix/_index.txt
sed -i 's/^/| /g' $tagprefix/_index.txt
sed -i 's/ |/\/index.html) |/g' $tagprefix/_index.txt
sed -i 's/| /| [/g' $tagprefix/_index.txt
sed -i 's/ /] /g' $tagprefix/_index.txt
sed -i 's/|]/|/g' $tagprefix/_index.txt
sed -i 's/] /](/g' $tagprefix/_index.txt
sed -i 's/](|/ |/g' $tagprefix/_index.txt

cat $tagprefix/_index.txt >> $tagprefix/index.txt
rm $tagprefix/_index.txt

echo "
|
|:----:|:----:|
| [Retornar aos posts](/posts/index.html) | [Retornar à home](/index.html) |
">> $tagprefix/index.txt

echo "Tag index prepared.
Will compile the tag index page..."

pandoc --to=html5 --from $panopts     \
       -o $tagprefix/index.html $tagprefix/index.txt \
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

sed -z 's/<table>/<table class=\"back\">/2' $tagprefix/index.html > posts.htm

mv posts.htm $tagprefix/index.html

echo "Tag index compiled."
