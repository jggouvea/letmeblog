#!/bin/sh

sh scripts/update_template.sh

echo "Template updated"

sh scripts/site_vars.sh

echo "Variables updated"
echo "Site configuration rewritten"

sh scripts/set_recent.sh
sh scripts/do_home.sh

echo "Homepage updated"
echo "Pinned post not changed"

sh scripts/do_pages.sh

echo "Stactic pages updated"

sh scripts/do_cats.sh

echo "Categories regenerated"

sh scripts/do_tags.sh

echo "Tags regenerated"

sh scripts/do_archives.sh

echo "Archives regenerated"

sh scripts/do_blogfull.sh

echo "Full post list updated"

sh scripts/do_posts.sh

echo "All posts recompiled"

sh scripts/do_atom.sh
sh scripts/do_rss.sh

echo "Feeds updated"

sh scripts/do_sitemap.sh

echo "Sitemap updated"

echo "Everything should be OK."
