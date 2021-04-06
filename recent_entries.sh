#!/bin/sh

rm recent.md recent.bak

ls -r posts/*.md | head -n 5 > articles.txt

pri=$(head -n 1 articles.txt)
seg=$(head -n 2 articles.txt | tail -n 1)
ter=$(head -n 3 articles.txt | tail -n 1)
qua=$(head -n 4 articles.txt | tail -n 1)
qui=$(head -n 5 articles.txt | tail -n 1)

titpri=$(grep "title" $pri | cut -d'"' -f2)
titseg=$(grep "title" $seg | cut -d'"' -f2)
titter=$(grep "title" $ter | cut -d'"' -f2)
titqua=$(grep "title" $qua | cut -d'"' -f2)
titqui=$(grep "title" $qui | cut -d'"' -f2)

lnkpri=/posts/$(basename $pri .md).html
lnkseg=/posts/$(basename $seg .md).html
lnkter=/posts/$(basename $ter .md).html
lnkqua=/posts/$(basename $qua .md).html
lnkqui=/posts/$(basename $qui .md).html

covpri=$(grep "coverImage" $pri | cut -d'"' -f2)
covseg=$(grep "coverImage" $seg | cut -d'"' -f2)
covter=$(grep "coverImage" $ter | cut -d'"' -f2)
covqua=$(grep "coverImage" $qua | cut -d'"' -f2)
covqui=$(grep "coverImage" $qui | cut -d'"' -f2)

bitpri=$(tail -n +2 $pri | grep -A 2 "\-\-\-" | cut -d'-' -f2 | head -n 3)
bitseg=$(tail -n +2 $seg | grep -A 2 "\-\-\-" | cut -d'-' -f2 | head -n 3)
bitter=$(tail -n +2 $ter | grep -A 2 "\-\-\-" | cut -d'-' -f2 | head -n 3)
bitqua=$(tail -n +2 $qua | grep -A 2 "\-\-\-" | cut -d'-' -f2 | head -n 3)
bitqui=$(tail -n +2 $qui | grep -A 2 "\-\-\-" | cut -d'-' -f2 | head -n 3)

echo "

## [$titpri]($lnkpri)

<figure class=\"coverImage\"><img src=\"images/$covpri\" alt=\"thumbnail\" /></figure>

$bitpri

## [$titseg]($lnkseg)

<figure class=\"coverImage\"><img src=\"images/$covseg\" alt=\"thumbnail\" /></figure>

$bitseg

## [$titter]($lnkter)

<figure class=\"coverImage\"><img src=\"images/$covter\" alt=\"thumbnail\" /></figure>

$bitter

## [$titqua]($lnkqua)

<figure class=\"coverImage\"><img src=\"images/$covqua\" alt=\"thumbnail\" /></figure>

$bitqua

## [$titqui]($lnkqui)

<figure class=\"coverImage\"><img src=\"images/$covqui\" alt=\"thumbnail\" /></figure>

$bitqui

" > recent.md

