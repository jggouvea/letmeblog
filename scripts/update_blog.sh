#!/bin/sh

sh scripts/update_template.sh

echo "Template updated"

sh scripts/do_home.sh

echo "Homepage updated"

sh scripts/do_pages.sh

echo "Pages updated"

sh scripts/do_cats.sh

echo "Categories updated"

sh scripts/do_tags.sh

echo "Tags updated"

sh scripts/do_archives.sh

echo "Archives updated"

sh scripts/do_blogfull.sh

echo "Post list updated"

sh scripts/do_posts.sh

echo "Posts updated"

sh scripts/do_atom.sh

echo "Feed updated"

sh scripts/do_sitemap.sh

echo "Sitemap updated"

echo "Everything should be OK."
