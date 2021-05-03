site_id="Your site name"
site_desc="A pithy quote to adorn your header"
baseurl="The domain you have hosted"
author="Your full name"
signature="the name by which you want to be known"
updmsg="something like \"Updated on: \" will do"
first_year=YEAR # Without quotes, when you began your blog.
this_year=$(date '+%Y')

# Replace catprefix and tagprefix with your localized names or
# the fancy names you want them to be known by.
catprefix=""
tagprefix=""
archive=""

# We'll extract some information that will be used in the templates:

# a) how big is my blog directory? how many posts in there?
postcount=$(ls src/posts/*-*.md | wc -l)

# b) how many tags do we have? This variable only works after
# you have run `get_tags.sh` once and its results are only
# reliable if you keep an eye on your taglist.
tagcount=$(cat taglist.txt | wc -l)

# c) how many categories? This variable only works after
# you have run `get_cats.sh` once and its results are only
# reliable if you keep an eye on your catlist.
catcount=$(cat catlist.txt | wc -l)

# d) when did I post for the last time?
last_post=$(stat -c "%w" $(find src/posts/$this_year-*.md -type f) | tail -n 1 | cut -d' ' -f1)
last_time=$(stat -c "%w" $(find src/posts/$this_year-*.md -type f) | tail -n 1 | cut -d' ' -f2)
update=$(date -u --date=$last_post '+%d/%m/%Y')

# Fonts for text and headlines

# Wherey they are hosted
fonturl="https://fontlibrary.org/face/"

# What are their names
textfont="cmu-concrete"
headfont="cmu-bright"

# Details after the name (Fontlibrary doesn't need any)
fontenc=""

# But exactly how will I evoke pandoc
panopts="markdown+smart+yaml_metadata_block+implicit_figures"
