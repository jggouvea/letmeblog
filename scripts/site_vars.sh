site_id="Letras Elétricas"
site_desc="Textões e ficções sem compromisso"
baseurl="http://letraseletricas.blog.br"
author="José Geraldo Gouvêa"
signature="J. G. Gouvêa"
updmsg="Atualizado em: "

# Replace catprefix and tagprefix with your localized names.
catprefix="categorias"
tagprefix="assuntos"
archive="arquivo"

# Unvariable variables... Don't mess with this part of the script.
# These are some failsafes.
first_year=2007
current_year=$(date '+%Y')
TIME="$(date '+%s')"
# We'll extract some information that will be used in the templates:

# a) how big is my blog directory? how many posts in there?
postcount=$(ls src/posts/*-*.md | wc -l)

# b) how many tags do we have?
tagcount=$(cat taglist.txt | wc -l)

# c) how many categories?
catcount=$(cat catlist.txt | wc -l)

# d) when did I post for the last time?
last_post=$(stat -c "%w" $(find src/posts/$current_year-*.md -type f) | tail -n 1 | cut -d' ' -f1)
last_time=$(stat -c "%w" $(find src/posts/$current_year-*.md -type f) | tail -n 1 | cut -d' ' -f2)
update=$(date -u --date=$last_post '+%d/%m/%Y')

# The templates
# We begin with a raw sidebar, where we have marked the places for the 
# information variables above. We copy it to another file (which Pandoc
# will actually use) and perform sed replacements in the copied file,
# preserving the original for a future run.

cp templates/sbar.txt templates/sidebar.txt

sed -i "s/POSTCOUNT/$postcount/g" templates/sidebar.txt
sed -i "s/TAGCOUNT/$tagcount/g" templates/sidebar.txt
sed -i "s/CATCOUNT/$catcount/g" templates/sidebar.txt

pageside="templates/sidebar.txt"
pagefoot="templates/footer.txt"

# Fonts for text and headlines
textfont="cmu-concrete"
headfont="cmu-bright"

# But exactly how will I evoke pandoc
panopts="markdown+smart+yaml_metadata_block+implicit_figures"
