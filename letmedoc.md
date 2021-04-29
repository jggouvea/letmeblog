---
title: "Blogging With Markdown and Pandoc"
subtitle: "Posting content from markdown files with shell scripts"
author: "José Geraldo Gouvêa" 
date: April 23th, 2021.
toc: true
...

# Introduction # 
From early 2010 to early 2021 I had a blog titled "Letras 
Elétricas", built upon WordPress, hosted at 
<http://www.letraseletricas.blog.br>, but I have recently been 
forced to ditch that reputable and foolproof 
[CMS](https://en.wikipedia.org/wiki/Content_management_system)
because it had become an ordeal to keep the website going. When
I had to find another way to build and keep my site, I suddenly
found that the existing solutions didn't cater to my needs,
so I was pressured to build my own tool, despite the fact that
I am not proficient in programming and barely know the basics
of shell scripting.

However, witness to the power of shell scripting, I was able to
create my personal solution to blogging, which, in spite of being
rather limited, can actually do what I needed the most: posts,
fixed pages, categories, tags, archives, news feed, sitemap and
dynamic landing page. That solution is this set of scripts which
I have named `letmeblog`.

This document describes how I wrote these scripts, how they
work and how they can be improved by the deft hands of someone
who may know better.

## Original inspiration ##
The creation of `letmeblog` was inspired by the work of one 
[Jilles van Gurp](https://github.com/jillesvangurp), a Belgian 
programmer who bravely exported his WordPress blog  into a set of
[Markdown](http://markdownguide.org) files because he wasn't
pleased with the way WordPress was handling his writing. He later
found a way to convert his posts and pages to static HTML using
[Pandoc](http://www.pandoc.org) by John Mac Farlane. Everything
I did was follow his footsteps, though, in all fairness, I had
a rougher path to tread and a longer distance to cover:

- Jilles' website features less than 100 pages and posts, while 
  mine had a whooping 910 --- which I eventually reduced to 810
  by merging, deleting or archiving posts.
- Back in 2010, when he exported his blog, there were WordPress
  plug-ins which handled importing, editing and exporting 
  Markdown from within the Control Panel itself; but these have
  either been deleted from the plug-in database, become 
  incompatible with newer WordPress versions or simply been
  abandoned by their creators.
- When I finally made my mind that I must move away from 
  WordPress; my blog was already faulty, unstable and dangerously
  heavyweight --- it wasn't easy to recover a recent and decent 
  XML backup including all recent posts and comments, as my 
  previous export file was missing some.
- Jilles' goals didn't include sorting posts by categories or 
  tags, nor did he mean to build neat post archive pages, so he
  could make do with fewer scripts and fewer pre and post 
  processing of his source files.
  
## Why the name ##
The name `LEtmeblog` was chosen as an acronym for "Letras Elétricas
markdown blog", in which "Letras Elétricas" is the name of
[my personal weblog](https://www.letraseletricas.blog.br), for which
I have written these compilation scripts, and the letter "e" was 
only added for [euphony](https://literarydevices.net/euphony).

## A note about philosophy ##
Most people want to have **automated** tools to perform tasks for
them. Automation is cool and useful, of course, and I, myself, am
the user of many such automated tools. However, when I am dealing 
with creative content, I happily give up automation for:

1. **Control**,
2. Modularity,
3. Flexibility,
4. **Speed**.

Retaking control of my content was one of the key reasons why I 
left WordPress and eventually decided to create my own blogging way,
after briefly trying alternatives like [Jekyll](https://jekyllrb.com),
[Pelican](https://blog.getpelican.com) and [Zola](https://www.getzola.org).

With WordPress, I was always under the impression that my content
was locked up in a binary format (SQL database) prone to binary 
corruption and requiring frequent backups which used a lot of
bandwidth and generated big downloads. Some of the tools to back up
the database were proprietary or even required payment, and none of
them gave me actual control of my content.

This situation worsened after WordPress became incompatible with a 
number of old plug-ins which allowed easy Markdown import and export,
or even storage of content in Markdown format. The new "Gutenberg"
editor rubbed salt onto the wound, as it was now impossible to
simply write my content elsewhere and paste it into the editor.[^gu]

[^gu]: Well, _in theory_ you can do that, but Gutenberg goes out of
its way to corrupt the content you paste. You actually spend more
time reviewing your post than you would if you had just written it
in Gutenberg already.

Content lock-up is apparently becoming a trend, even in so-called
"Open Source" software, like WordPress. And that's intollerable
because I want to keep my content _mine_ in the first place.

Another problem with WordPress blogs, which seems to be replicated
in many other platforms, including some that purport to use Markdown
inputs, is that you don't actually control the process by which the
source file becomes a blog. There is a template, there are scripts 
you will host or run and there are some source files to be processed 
--- but the actual conversion isn't transparent and you can't 
interfere easily with it.

`letmeblog` addresses these concerns by splitting the generation of
the website in a set of scripts which can all be run separately,
giving you control of what you are generating in each step. Moreover,
by allowing you to stop and restart compilation at any time, it saves
you time and processing power as you can prevent the full execution
of a command that will _not_ generate your site cleanly.

Nowadays website content is _generated_ from source files, that's
the way things are done. Source files can be reused for the production
of different outputs, or for inclusion in other source files. In a
traditional blog your content is rarely ever reusable. In fact, if 
you want to generate e-books or PDFs from your content, you have to
keep a separate source file offline, in your computer, which creates
a permanent problem with versioning.

With `letmeblog` you keep your content conveniently stored in 
Markdown files, which you can reprocess to create different HTML
versions, as well as producing EPUB, PDF or even MS Word versions,
if need arises. You can keep your files versioned using `git` and 
you can write scripts to recombine or split your source files to 
produce different outputs.

And finally there is the problem of **speed**, which was my second
biggest concern about WordPress, as my blog was growing ever slower
as it grew in size. Every new page or post I added seemed to increase
the performance overhead, as the database had to be queried multiple
times by the server. As more visitors came, server overhead made the
site unusable for long periods of time, causing my visitor count to
drop from almos 200 a day to less than 70.

A static website has no such issues. Pages are served super-quickly
as there is little processing to be done server-side. Granted, I have
lost the ability to actually track my visitors, or to store their 
comments, but both are blessings in disguise --- especially that about 
comments, as most of these were spam anyway, and legit commentators
often left garbage remarks which added little to the actual content.
Social networks have largely replaced fora and comment systems, so
there's no point trying to keep such things in my blog. 

Very soon people will regard comment systems more or less like
"[guestbooks](https://en.wikipedia.org/wiki/Guestbook)", which used
to be all the rage around the turn of the century, but are now some
relic that no cool website actually uses prominently.

As for visitor count, social network impact is a much more useful
thing to measure. It doesn't matter, in terms of relevance, that 
200-odd people have stumbled upon your site if most of them have
not stayed and fewer will ever return.

Therefore, `letmeblog`, though it goes back to the olden days of
static websites, is not actually dropping much in terms of actual
usability. It only needs to be improved with new features (like
page navigation, which is still sorely missing).

## Licensing issues ##
_Most_ of my scripts are _inspired_ by Jilles', but not identical
to them. The exceptions are `do_atom.sh` and `do_sitemap.sh`,
both of which are almost identical to Jilles' originals.

All in all, Jilles' site is compiled by a few commands he invokes
from a `Makefile` (which I have opted not to use), while my blog
is compiled by a set of fourteen separated scripts, which have 
to be run separately. I have developed my own scripts for most
of the tasks and the similarities to be found don't result from
plagiarism, but from the very nature of Pandoc, which takes a 
limited set of command-line arguments. Even the template I use
has been heavily modified from Pandoc's own HTML template, with
a few hints taken from Jilles' template.

I do recognise that I have _built upon_ his work, and for that I
duly give him credit, but I owe about as much to 
[Stackexchange](https://stackoverflow.com)... if you know what I
mean. Anyway, Jilles kindly put his work under the 
[MIT/Expat license](https://mit-license.org/), which is a
[copyleft](https://www.gnu.org/licenses/copyleft.html) license.
Out of my own will, I would have rather used the 
[GPL](https://www.gnu.org/licenses/licenses.html), but, since
Expat and GPL are compatible, it makes sense to keep his choice.
Therefore, the scripts are provided under the MIT/Expat license,
even the parts I developed autonomously.

# Scripts #
The blog building system is made up of fourteen shell scripts, which
you will put into a `scripts` directory under the build root:

1. `get_cats.sh` 
2. `get_tags.sh` 
3. `get_years.sh`
4. `set_recent.sh` 
5. `set_pinned.sh`
6. `do_home.sh`
7. `do_cats.sh`
8. `do_tags.sh`
9. `do_pages.sh`
0. `do_posts.sh`
1. `do_blogfull.sh`
2. `do_archives.sh`
3. `do_atom.sh`
4. `do_sitemap.sh`

Scripts up to #5 are preprocessing steps (the first don't have to be
run every time you update the blog). 

Scripts from #6 to #12 are compilation steps and should be always run
whenever you:
- Create a new post;
- Categorise to a post;
- Tag a post;
- Remove a post from a category;
- Remove a tag from a post;
- Create a new tag or delete one that existed;
- Create a new category or delete one that existed.

If you are unsure about the order you should run the scripts, you can
use the mnemonic: "get, set, do". Never run a "set" script before you
have run the "get" ones and never run a "do" script before running
a "set" script. "Get" scripts only need to be run when you first build
the blog, after that you can maintain them by hand. "Set" scripts only
need to be run when you add new content. "Do" scripts need to be run
every time.

Unless otherwise specified, the scripts don't take arguments nor have
options. Simply run them from the build root:[^buildroot]

[^buildroot]: For the purposes of this document, the term "build
root" will be used for the working directory where you will compile
your blog. If you are in Linux, like me, it's useful to put the
scripts and their content in a directory read by your local http
server, so you can develop the blog live, before you upload it.

`sh scripts/do_home.sh`

Other than that, you have some extra scripts, for specific purposes:

1. `update_post.sh`
2. `update_template.sh`

`update_post.sh` is to recompile one single post, if you notice some
problem specific to it. 

Usage: `sh scripts/update_post.sh src/posts/XXXX-XX-XX-postname.md`

The script will silently and gently generate the HTML output in the
`posts/` directory.

`update_template.sh` is to regenerate the HTML template if you make
changes to its parts. You will know why this is useful later in this
document.

# Requirements #
The scripts are quite simple and will probably work in any Linux
distribution, as well as any POSIX-compliant operating system
which features the packages listed below:

Pandoc
: for markdown compilation;

`bash`
: to actually execute the commands;[^bash]

[^bash]: I have actually tested the script with `zsh` and it worked
just fine. In fact, the early development was in `zsh`. I only moved
back to `bash` because I noticed that it is more strict in syntax
validation, which means that, unless I use "bashisms", a script that
was developed and tested under `bash` is more likely to work with well
under `zsh` than the other way around.

GNU "coreutils"
: for source files preprocessing;

`jq`
: to extract metadata from Markdown files;

GNU `sed`
: for source file preprocessing and for some HTML post processing
  as well;[^sed]
  
[^sed]: I am not sure whether the script will work with
  non-gnu `sed`, but, afaik, it probably will.

From "coreutils", the commands actually used in the script are
`basename`, `cat`, `column`, `cp`, `cut`, `date`, `echo`, `find`,
`grep`, `ls`, `mkdir`, `mv`, `paste`, `printf`, `readlink`,
`rm`, `seq`, `sort`, `source`, `stat`, `tail`, `tr`, `uniq`
and `wc`. 

Users of lightweight distributions of Linux (like Slitaz and
Tiny Core) might not be able to run these scripts, as these
distros ship "busybox" as a replacement for Coreutils, but your
mileage may vary.

# Blog structure #
Before you begin using the script you have to feed it content in 
a predictable way. This is not a "smart" content management 
system like WordPress and others: these scripts are only as 
"smart" as the user (and their creator). If you don't understand
the scripts and feed them unstructured information, they will
either fail or mangle your source files. **Be warned!**

## Folders ## 
Unless you make changes to the scripts (which you are by all 
means invited to do if you know what you are doing), they depend
on a given directory structure, created in the directory where 
you will keep your "build root":

- `templates`  : the HTML template and a few other snippets;
- `src/pages`  : for fixed pages, like "About", "History" etc;
- `src/posts`  : for the dynamic content;
- `images` : full-size pictures;
- `posts`  : empty directory to receive the posts HTML;
- `pages`  : empty directory to receive the pages HTML;
- `tags`   : empty directory to receive the tags dirs;
- `categories` : empty directory to receive the category dirs;
- `archives`   : empty directory to host the archives;
- `scripts`: where you'll put the shell scripts.

Though I have not yet fully implemented the concept, some of
these directories support name customisation by changing lines in 
the `site_vars.sh` file.

## Templates ##
The HTML template (filename `blog.html`) is generated by the 
`update_template.sh` script, from the following files:

1. `head1.tpl`
2. `head2.tpl`
3. `head3.tpl`
4. `head4.tpl`
5. `head5.tpl`
6. `head6.tpl`
7. `body.tpl`
8. `foot.tpl`

These files are not meant to be edited, unless you know well what 
you are doing and why. Their different functions are explained 
further down.

The actual templates you want to customise are called `sbar.txt` and 
`footer.txt`. Other than that, you don't need to change any templates,
just edit the variables file (`site_vars.sh`) in the `scripts` 
directory and that will be used to fill in the placeholders.

`sbar.txt` : is your navigation section, where you will write your
navigation links and any other content you want to put in your 
sidebar or menu.

`footer.txt` : contains your copyright claim (if any) as well 
as any messages you want to appear below every page.

A file named `sidebar.txt` is created in the same directory by
the output of the scripts --- it's safe to delete it whenever
you want, but it will always come back, so don't bother.

## Source tree ##
The blog source tree (`src/`) keeps the landing page info 
(`src/index.md`), blog posts (`src/posts/`) and fixed pages 
(`src/pages/`). Throughout the source tree, Markdown files
(suffix `.md`) are the content you write and plain text files 
(suffix `.txt`) are produced by scripts processing your content,
throughout the many phases of compilation, and HTML files 
(suffix `.html`) are the output content produced by Pandoc.

All site content must be writting in Markdown. You can
use any Markdown features supported by Pandoc (do read
their documentation and add the required extension code to
`src/site_vars.sh`). The default Pandoc invocation I use is
`markdown+smart+yaml_metadata_block+implicit_figures`, which
means "Pandoc's own markdown dialect, extended with smart
punctuation, yaml metadata blocks and putting images in a
'figure' environment by default". I find this setup pretty
basic, but powerful enough to provide good quality. Unless
you need something specific, like MathML, LaTeX output etc.,
there is no need to change it.

### The landing page ###
The default landing page contains three blocks of content:

Site greeting 
: read from the `index.md` which you write in the source tree.

Pinned content
: which is compiled from a post or page you have symlink to
`pinned.md` in the build root.

Recent posts 
: compiled from a file called `recent.txt` created in the 
build root previously to compilation.

Any content you write to the `index.md` file will appear at
the top of the landing page in a larger font.

If you delete (or never create) a `pinned.md` file, the landing
page will not have a pinned content area.

Anything else you want to change (or if you want to add content
after the recent posts), you must change the script that compiles
the homepage.[^rposts]

[^rposts]: Don't mind the thumbnails, they are already honoured by
the scripts if you include a "coverImage" directive in your `yaml`
metadata.

### Fixed pages ###
Fixed pages have plain names, preferably short and easy to 
memorise --- like `bio.md`, `about.md`, `blogroll.md`, etc. These
names will result in URLs like `http://baseurl/pages/bio.html`,
which are meant to be easy to be remember. Whatever really
important information should have such URLs, but they must be
used sparingly, as pages don't organise content.

### Blog posts ###
Blog posts must be written in Markdown and named according to 
`YYYY-MM-DD-post-title.md`; in which `YYYY` is the year written
as four digits (e.g. "2021"), `MM` is the month in two digits 
(e.g. from "01" to "12") and `DD` is the day in two digits (from
"01" to "31"). The date must be written with hyphens to keep the
URL working. Words in the filename can be separated by either
hyphens or underscores (as you wish, but _not_ by spaces or 
special characters other than these). The `YYYY-MM-DD` block must
be separated from the title by a hyphen.

These are valid blog post file names:

	2021-11-16-a-trip-to-london.md
	2021-11-16-A-Trip-To-London.md
	2021-11-16-A_Trip_to_London.md
	2021-11-16-a_trip_to_london.md
	2021-11-16-a_trip-to_london.md

But these aren't (if you're even able to create files named as
such in your system, which you may not be, I'm afraid):

	2021_11_16_a_trip_to_london.md 
	2021-11-16-a trip to london.md
	2021-11-16-a%trip%to%london.md
	2021/11/16-a*trip*to*london.md
	2021-16-11-a-trip-to-london.md

The last one will not spit an error, but will result in gibberish
because there is no 16^th month.

### Metadata ###
Post metadata shall be written in `yaml` format and included in
the _beginning_ of the file. In theory, a metadata block can be
included anywhere in the post, but for the sake of clarity and
organisation it's already better to put it there. For the purpose
of this script, putting a `yaml` block elsewhere _may_ not harm
the output, but will be ignored at best.

The scripts need at least "title" and "date" to generate the blog
without issues. If you won't use categories and tags, you may
not include them in the sources, but there's really no point in
refusing to use them, as they are so darn useful.

You can include a "toc" metadata (either "true" or "false"),
in really long pages or posts, with many sub-headings. I have
prepared the scripts to recognise the "toc" metadata and proceed
accordingly.

You can also include a "coverImage" metadata, pointing to an 
image file. The script will use this image file as the thumbnail
shown in some post lists.

Any other metadata declarations will _probably_ be ignored, but
aren't safe to include, unless you know well how Pandoc handles
them. I don't claim to be an expert in that particular matter.

### Text formatting ###
All content is just [Markdown](http:markdownguide.org), which
you probably know what is at this point. If you don't, do take 
some time to read some documentation about the format. If you
don't need much in terms of formatting, you'll probably do well
with the most basic knowledge, that is:

- Write plain text in a text editor, not in Word or whatever
  that is even remotely similar to Word;
- Blocks of text separated by empty lines make paragraphs;
- Emphasise passages using asterisks (one for italics, two for
  boldened text);
- Subheadings are made using hashes (up from two to six, as you
  go deeper in subheading nesting), but don't use one hash only
  (as in `# Heading 1`) because the first-level heading is 
  reserved for the post title, which is given by the `yaml`
  metadata block.

If you need more than this, then you **do** need to read the full
documentation.

### Images ###
To keep the build tree tidy you should create an `images` folder
in the root directory and put all images there. There's no 
specification for image format, of course, but my experience is
that JPGs are better for detailed images that will appear at a
bigger size and PNG files are better for everything else.

The reason why I prefer JPGs for big images isn't quality,
but bandwidth saving as they have better (lossy) compression for
photographs. Ideally, you should resize all images down to 100%
of the minimum width of your text area. That way you don't use
too much transfer bandwidth with images that are bigger than
absolutely necessary.

# Templates #
Pandoc will build the site from a set of templates, which you 
can customise, of course. Three of them are required and a fourth
you can add if you wish.

## The HTML5 template ##

The default Pandoc HTML5 template is pretty basic and nothing
much needs to be changed in it, unless you know very well what
you are doing.

The beginning part is especially unchangeable:

```{.html}
include{templates/head1.tpl}
```

Now comes styling. I have used open-source fonts from the 
[Open Font Library](https://fontlibrary.org) and the scripts 
expect them, but you can pick any fonts you want, you just need 
to adjust the template and the stylesheets. If you plan to use 
fonts from OFL as I did, put their names in the `site_vars.sh` 
file as the "text" and "head" variables and then follow the
guidelines for font-face choosing, which are found in the CSS
files themselves.[^ofl]

[^ofl]: I don't particularly love the Open Font Library, but... hey!
They aren't Google!

```{.html}
\include{templates/head2.tpl}
```

Local style sheets will hold your actual styles. I have preset
four style files, loaded in this specific order, so that they
"cascade" as expected, resulting in a consistent and responsive
layout.

```{.html}
\include{templates/head3.tpl}
```

The two last things are the link to the Atom Feed (a pretty basic
one) and to the Font Awesome kit providing the basic icons. 
_I use them_, the setup is free and there's no real reason not to
use Font Awesome, unless you absolutely don't know what to do 
with it. At this moment, I only use five of their icons, to build
the Creative Commons licensing at the footer and to create a 
warning icon I use in some places, but I will use Font Awesome
more often in actual _post content_.

```{.html}
\include{templates/head4.tpl}
```

Before the actual page content there are two more bits to add, the
site header and the sidebar/menu.

```{.html}
\include{templates/head6.tpl}
```

The sidebar is actually a misnomer, as this is where navigation
goes. It can be either a sidebar, if you are a conservative, like
me, be styled in the most outlandish way you wish. Know your CSS
and make it your way.

The main content area in the template is the same for both posts
and pages: there are conditions put in place that will format
the output depending on the presence or absence of certain
variables. By default the publish date, the tags and categories
variables are not evoked by the page compilation script, only
by the article compilation; so, it doesn't matter if you add
tags and publish dates to a page, they won't appear anywhere.

```{.html}
\include{templates/body.tpl}
```

And finally comes the footer area, which will just print the
contents of your footer file.

```{.html}
\include{templates/foot.tpl}
```

Future versions of this may remove the sidebar and footer variables
from Pandoc's evocation, as these can be more easily inserted directly
into the template file. The reason why I have not yet done that is
that having separate template bits and template inputs can preserve
a way to insert content via command line, which _may_ be useful,
though I am not yet sure when or how.

### The `sbar.txt` input file ###
You can structure your navigation any way you want, but I advise
you to base it on the following elements, to make CSS styling 
a bit easier:

- `<div role="navigation" class="navigation">` : where you will
put your main links in an `<ul class="menu">`

- `<div class="bloglinks">` : for links of lesser importance,
also in an `<ul class="links">`

- `<div class="widget">` : for any other element which is not
a link.

### The `footer.txt` input file ###
You can put anything in your footer, but I advise you to include,
at least, your copyright information (`<div id="license">`)
separated from random site info (`<p id="site-info">`). My own
site has the following information in the footer:

- CC-BY-ND-SA (icons) Creative Commons Attribution Non-Derivative
  Share-Alike license tag (with the respective link).
- An appeal for correct content attribution.
- An explanation about the use of Markdown and Pandoc to compile
  the site and an attribution to Jilles van Gurp for inspiration.
- Mention of the Open Font Library, where the fonts are hosted.
- Links to the code repository.

# Processing the blog #
Blog processing is done in stages:

1. Content creation (don't even start if you have nothing to post...);
2. Folder setup (`mkdir` the places you will use, `chmod` the 
   directories, `symlink` them, if need, edit the webserver config
   if you plan to develop live etc.);
3. Variables setup (edit the `site_vars.sh` script);
4. Preprocessing
5. Compilation
6. Upload

This document is about steps 3 to 5. The first one you must do on
your own (I can't provide any advice on that), the second has been
explained [above](#folders) and the last one each user will choose
to do differently.

## Setting up site variables ##
The file `site_vars.sh` stores a series of variables that will be
read by every other script from now on. It is an absolute requirement 
that you edit it before you do anything else. I have provided a blank
one, that you need to fill in. _Every variable is required_, though
they some can have blank values.

```{.bash}
\include{site_vars.sh}
```

Having set up your varibles, time to move on to actually building 
your blog, which you _should_ do in the following order:

## Preprocessing ##
Preprocessing consists of _optional_ steps that gather information
to be later used in building the site. Most preprocessing can be
done once and never again, if you are careful. Anyway, if you need
to run them, do make a full build to update everything.

### Listing the categories ###
As you've been told, _categories_ refer to the textual genre of
the post. Therefore, you won't have too many. My own blog does
only have the following: "short stories", "reviews", "articles",
"flash fiction", "essays", "incomplete", "fragments", "novellas",
"novels", "updates", "opinion", "musings", "translations",
"tutorials", "poetry" and "criticism".

This script reads all blog posts in `src/posts/` and feeds them
into Pandoc, which then pipes them to `jq`, which lists the 
categories into a file called `catlist.txt` in the build root.
This file is renewed every time the script is run.

```{.bash}
\include{scripts/get_cats.sh}
```

In theory, you only need to run this script exactly _once_, when
you setup the blog, and even then, only if you have a large 
number of posts imported from a WordPress installation. If you 
are manually adding posts to your blog, _after_ you have compiled
it, or if you are writing your blog from scratch, it's probably
better to just curate yourself a list of categories named 
`catlist.txt` in the build root folder. Just put each category in
a line of its own, using underscores to link words, thus avoiding
spaces in filenames. And remember not to delete it by accident.

### Listing the tags ###
As you've been told, _tags_ refer to the subject matter of the
post. Therefore, you can have as many as you need or wish. My 
blog used to have about 300 of them, thanks to the _useful_ 
contribution of my readers, who couldn't resist tagging my posts
when I enabled the "comments can add tags" WordPress plugin. 
However, having too many tags defeats the purpose of having tags
anyway _and will slow your blog_.

The script is identical to `get_cats.sh` (but for replacing tags
for categories where needed). It reads all posts in `src/posts/`
and feeds them into Pandoc, which then pipes them to `jq`, which
lists the tags into a file called `taglist.txt` in the build 
root. This file is renewed every time the script is run.

```{.bash}
\include{scripts/get_tags.sh}
```

In theory, you only need to run this script exactly _once_,
when you setup the blog, if you have a large number of posts
imported from a WordPress installation. If you are adding posts
to your blog, _after_ you have compiled it, or if you are writing
your blog from scratch, it's probably better to just curate
yourself a list of tags named `taglist.txt` in the build root
folder. Just put each tag in a line of its own, using underscores
to link words, thus avoiding spaces in filenames.

### Finding the recent posts ###
Every time you add a new entry to your blog you must make it 
appear in the landing page, so your visitors know about it. This
script does just that, it lists the six most recent files you
created there, greps them for content and formats the information
in HTML, redirecting that into a file named `recent.txt` in the
build root.

At this point the scripts will identify the most recent post in
your source tree and store its date in a variable which will be
added to your "sidebar", advertising to the world when you last
posted something. 

```{.bash}
\include{scripts/set_recent.sh}
```

This is _all_ that this script does. It doesn't really compile
anything, it just prepares a list of recent posts that will be
later used to compile the landing page.

### Setting up the pinned post ###
Pinned content is what you want to have in your landing page,
regardless of its recency. Content you don't want to replace with
your newer content. You could write this content into the
`index.md` file, but that could be too cumbersome if your pinned
content is long and complex. Here comes the `set_pinned.sh`
script to rescue:

```{.bash}
\include{scripts/set_pinned.sh}
```

This script does for the pinned post, which you have manually
symlinked to `pinned.md`, the same that `set_recent.sh` does
for recent posts, but it doesn't need a cover image, as it uses
a FontAwesome-provided warning icon.

You will notice that it outputs to `pinned.txt`. There are two
files named "pinned" in the build root, one is a symlink to a
Markdown file you have written, the other is a text file created
by this script. If you link your pinned content to `pinned.txt`
instead of `pinned.md` something nasty will happen: you will 
destroy the contents of the file containing your pinned post.
**So, don't do that!**

## Compilation ##
Because all scripts process the Markdown source files in the source
tree and write to the output folders in the build root directory,
they don't depend on the HTML output for anything. The "do" scripts
can also be used in any order as well.[^order]

[^order]: Though the `atom.xml` and `sitemap.xml` link to html 
files, in practice they are produced by processing Markdown 
inputs, like everything else.

### Building the landing page ###
Once you have written your greetings, set a pinned post and have
written at least six posts, you can compile your landing page:

```{.bash}
\include{scripts/do_home.sh}
```
  
This is the first time Pandoc is actually evoked to process 
Markdown files. Everything here is fed up from the `site_vars.sh`
file (which you have surely edited to your liking) and based on 
the HTML5 template (here called `blog.htm`, but you can name it
anything you want), the sidebar and the footer. Just change the
language tag from ("pt") if you don't write in Portuguese. 
There's nothing else special here.

This is also the same basic Pandoc evocation that will be used
again and again in the next steps, only changing the inputs
and outputs.

You can see, in the end, that Pandoc concatenates the three
input files (`index.md`, `pinned.txt` and `recent.txt`) before
processing them, and writes the output to `index.html` in the
build root.

### Category pages and category index ###
This script reads all blog posts in `src/posts/` and greps them
for the categories listed in the `catlist.txt` file in the build
root. The filenames are written to a list that will be input in
a later stage. In the end, the script builds a page for every
category listing posts belonging to it, and then an index page
listing all categories.

```{.bash}
\include{scripts/do_cats.sh}
```

As you can see, we generate one `index.html` page for every
category, and then an `index.html` for the categories folder
itself, containing a table with all categories in it.

### Compiling tag pages and tag index ###
The `do_tags.sh` script does more or less the same as the 
`do_cats.sh` script, except that it works with the "tags"
taxonomy. A few bits here and there are tweaked, but the
script is basically the same. Besides changing `$catprefix`
for `$tagprefix` in every line, you must adjust the column
width from `column -x -c 150` to `column -x -c 230` because
tags tend to have longer names than categories and the table
will not work then (you don't need to do that, though, if the
script works for you).

```{.bash}
\include{scripts/do_tags.sh}
```

You can ajust the column width in both scripts, if you need,
to ensure that a corrent table is generated. The desired output
is a three-column table in each case.

### Fixed pages ###
Fixed pages are quite easy to process, since they don't have
tags. It's just a case of cycling through their filenames and
processing each of them:

```{.bash}
\include{scripts/do_pages.sh}
```

### Blog posts ###
This is a quite time-consuming part of the compilation (after 
getting tags and cats). So much so that my current plans include
a script to compile only the last "n" posts (a partial blog
update). My own blog takes 144 seconds to compile all posts
(they being so many).

The script itself isn't much complicated, though:

```{.bash}
\include{scripts/do_posts.sh}
```

I keep my full list as `posts/archive.html`.
I do link to it from the landing page.

### Archive of posts by year ###
This is one of the coolest things I have been able to do in shell
script, which Jilles didn't do (probably because he didn't need 
or want to, as he didn't do categories and tags either). This 
required quite a lot of tweaking before it worked. You will 
probably have to adjust the CSS very well before it looks good 
for you, but it _is awesome!_


```{.bash}
\include{scripts/do_archives.sh}
```

Here the archives are ready to be linked to from the homepage and
the sidebar (which is their sole purpose, if I am not wrong).

### Atom feed ###
Though site feeds are less important nowadays, since Google
killed its Feedburner and Reader services, many people still use
them to follow their favourite blogs. So I think it's nice to
provide at least one type of feed. I use an Atom feed because
that was what Jilles used, but I will eventually find a way to do
RSS 2.0 instead.


```{.bash}
\include{scripts/do_atom.sh}
```

I have actually made a few modifications to Jilles' script, though 
it's still much the same and uses the same template. However, as you
can see, the resulting `atom.xml` file is not well-formatted. There's
a lot of room for improvements.


### Sitemap ###
Sitemaps are useful to get yourself a higher SEO ranking. This
script is basically the same as Jilles':


```{.bash}
\include{scripts/do_sitemap.sh}
```

## Uploading ##
After done the compilation, you only have to upload the generated
content to your webserver, for which you will probably use your
trusty FTP transfer utility or some `rsync` spell.

I have chosen to do that manually, instead of scripted, because 
of bad misfortunes I had in the past, using buggy `rsync` scripts
which, instead of uploading my files to an empty directory in 
the cloud, instead _deleted_ my local files so the two places 
were exact "mirrors" of each other (though not the way I wanted).

If you have too many images, the upload will take very long (my
initial commit took almost one full hour), but for the text files
it is very fast.

My preferred upload method is the mirroring command from `lftp`:

`mirror -R localdir remotedir`

Which you will invoke _after_ logging into your FTP server using 
`lftp` and changing your local directory to your build root.

In case you didn't change directory before logging in, you can still
do it with the command `lcd`, which takes the full path (unless you
are changing into a subdirectory of the current folder).

In _my case_, as an example, I do this:

```
lftp -u myuser ftp.mydomain.com.br
cd ..
mirror -R -x templates -x src -x scripts --ignore-time public_html www
```

One good thing about the "mirror" command in `lftp` is that it will
only transfer the files which have changed. This means it will 
probably re-upload your entire set of HTML, as well as any files you
have edited, but _not_ if you add the `--ignore-time` switch, which
instructs `lftp` to only upload files that have been added or which
have changed in bytesize.

Recompiling your entire blog with the `do_posts.sh` script, for 
instance, will change the HTML files timestamp, but if no change has
been made, the size in bytes may still be the same, which will 
prevent re-upload and save you bandwidth and time.

## To be added ##
`letmeblog` is mostly complete, at this point, as there is little I 
am _capable_ of adding. However, some useful features it could use,
and which you could help me build, are:

- Pagination, or "page navigation" for large content lists;
- Next and previous posts;
- Local search (a simple `grep` would suffice).

Some features are going to be implemented or improved as soon as I
find enough documentation:

- Improved `robots.txt`;
- Improved `.htaccess`;
- Fully functional atom feed;
- Alternative RSS feed;

Some other features are already in planning, but might be delayed,
as they are too specific for my needs:

- PDF and EPUB generation for sets of files ("anthologies");
- CSS editing based on font embedding (currently `letmeblog` wants you
  manually edit your CSS files replacing font declarations if you
  change the font embedding link);
- Social network links.

You are invited to help me improve `letmeblog` whatever way you can.

# Conclusion #
If you like this, visit me at <http://letraseletricas.blog.br>,
find my social network places and help spread the word about my
work as a fiction writer and translator.

Thank you for reading up to this point. I hope you can produce 
your own blog using my tool. But if you don't, remember the old
adage of the GNU gurus:

> THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED 
> BY APPLICABLE LAW. EXCEPT WHEN OTHERWISE STATED IN WRITING THE
> COPYRIGHT HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM 
> “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
> IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
> OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE 
> ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM 
> IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME 
> THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.

> IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN
> WRITING WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO 
> MODIFIES AND/OR CONVEYS THE PROGRAM AS PERMITTED ABOVE, BE 
> LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, 
> INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR 
> INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS
> OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED
> BY YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE
> WITH ANY OTHER PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY
> HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.

## Legalese ##
Scripts licensed under the [MIT/Expat](https://mit-license.org).

Scripts `do_atom.sh` and `do_sitemap.sh`:
Copyright © 1999-2020 by Jilles van Gurp

Other scripts and templates
Copyright © 2021 José Geraldo Gouvêa

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the 
“Software”), to deal in the Software without restriction, including 
without limitation the rights to use, copy, modify, merge, publish, 
distribute, sublicense, and/or sell copies of the Software, and to 
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be 
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, 
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
