#!/bin/sh
gpp --nostdinc -I/home/jose/public_html/letmeblog/scripts/ \
-I/home/jose/public_html/letmeblog/templates/ -T letmedoc.md | \
pandoc --from=markdown+smart --highlight-style tango -s \
--to=html5 -o letmedoc.html

sed -i 's/max-width: 36em;/max-width: 50em;/g' letmedoc.html
