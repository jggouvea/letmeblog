<!DOCTYPE html>
<html$if(lang)$ lang="$lang$"$endif$$if(dir)$ dir="$dir$"$endif$>
  <head>
    <title>$title$</title>
    <meta name="generator" content="pandoc" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
$for(author-meta)$
    <meta name="author" content="$author-meta$" />
$endfor$
$if(date-meta)$
    <meta name="dcterms.date" content="$date-meta$" />
$endif$
$if(description)$
    <meta name="description" content="$description$" />
$endif$
$if(tags)$
    <meta name="keywords" content="$for(tags)$$tags$$sep$, $endfor$" />
$endif$
    <meta property="og:type" content="website" />
