#!/bin/sh

source $(pwd | cut -d'/' -f1,2,3,4)/site.cfg

sitemap="sitemap.xml"
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

function url() {
  echo "<url><loc>${baseurl}/$1</loc><lastmod>$timestamp</lastmod></url>"
}

robots=`cat <<EOF
User-agent: *
Allow: *
Sitemap: /sitemap.xml
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

for pcat in $(find categorias -name "*.html" | sed -e 's/categorias\///'); do
  echo $(url $pcat) >> $sitemap
done

for ptag in $(find assuntos -name "*.html" | sed -e 's/assuntos\///'); do
  echo $(url $ptag) >> $sitemap
done

printf "</urlset>\n" >> $sitemap
