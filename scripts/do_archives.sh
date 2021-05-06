#!/bin/sh
source scripts/site_vars.sh

echo "---
title: \"Página de índices\"
---

|
|:--------------:|:-------------:|:---------------------:|
| [artigos por categoria](/$catprefix/index.html) | \
[artigos por assunto](/$tagprefix/index.html) | [lista completa]($archive.html) |

" > posts/index.txt

for blogpost in $(find src/posts -type f -iname "*.md" | sort -r | head -n 10); 
do
fdate=$(echo $blogpost | cut -d'/' -f3 | cut -d'-' -f1,2,3)
pyear=$(date -u --date=$fdate '+%Y')
pdate=$(date -u --date=$fdate '+%d/%m/%Y')
plink=$(echo $(basename $blogpost .md).html)
title=$(grep -e "title: " $blogpost | cut -d':' -f2,3 | cut -d'"' -f2)
echo "- <b class=\"pdate\">$pdate</b> - [$title](/posts/$plink)" >> posts/index.txt
done

rm -rf $archive/*

for Year in `cat years.txt`;
do
ind=$archive/$Year/index.txt
tmp=$archive/$Year/posts.txt
rm -rf $ind $tmp
rm -rf $archive/$Year
mkdir -p $archive/$Year

echo "---
title: Artigos publicados em $Year
---

" > $ind

for blogpost in $(find src/posts/ -type f -iname $Year-\*.md | sort -r);
do
    fdate=$(echo $blogpost | cut -d'/' -f3 | cut -d'-' -f1,2,3)
    plink=$(echo $(basename $blogpost .md).html)
    pdate=$(date -u --date=$fdate '+%d/%m')
    title=$(grep -e "title: \"" $blogpost | cut -d'"' -f2)
    pyear=$(date -u --date=$fdate '+%Y')

  echo "- <b class=\"pdate\">$pdate<b> - [$title](/posts/$plink)" >> $ind
  echo "Encontrado \"$title\", de $pyear."  
done

pandoc --to=html5 --from $panopts       $ind  \
       -o     $archive/$Year/index.html   \
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
title: \"Arquivo do blog\"
---

" >> $archive/index.txt

echo "
|
|:----:|:----:|:----:|" > tab.txt

cat years.txt | sort -r | sed "s/^/(\/${archive}\//g" | sed 's/$/\/index.html)/g' > ylinks.txt
cat years.txt | sort -r > xyears.txt
paste xyears.txt ylinks.txt | sed 's/^/[/g' | sed 's/\t/]/g' > yyears.txt
cat yyears.txt | column -x -c 120 | sed 's/^/| /g' | sed 's/$/ |/g' | sed 's/\t/ | /g' >> tab.txt

cat tab.txt >> $archive/index.txt
rm -r ylinks.txt yyears.txt

pandoc --to=html5 --from $panopts       $archive/index.txt  \
       -o     $archive/index.html   \
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

sed -i 's/<table>/<table class="years">/g' $archive/index.html
	   
cat tab.txt >> posts/index.txt

pandoc --to=html5 --from $panopts       posts/index.txt  \
       -o     posts/index.html   \
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

	   
sed '0,/<table>/{s/<table>/<table class="blog-header">/}' posts/index.html > posts.htm
mv posts.htm posts/index.html
sed -i 's/<table>/<table class="years">/g' posts/index.html
