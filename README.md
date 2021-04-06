# LEtmeblog
LEtmeblog is a static blog compiler made purely in shell scripting, using markdown as the source format<sup>[1](#markdown)</sup> and Pandoc<sup>[2](#pandoc)</sup> as the backend.

This thing was directly inspired by [Jilles van Gurp](www.jillesvangurp.com), who was the first (afaik) to use custom BASH scripts to evoke Pandoc and built a static site from a set of Markdown files exported by Wordpress. I even used his Pandoc templates and expanded my build script from the few individual ones he uses. You can compare my work to his visiting [his GitHub repo](https://github.com/jillesvangurp/www.jillesvangurp.com).

A spiritual inspiration (which didn't actually provided any input) was Carlos Fenollosa's [`bashblog`](https://github.com/cfenollosa/bashblog) script.

## Design goals

- Implement the most useful and usual features of a Wordpress blog;
- Requiring the least possible amount of dependencies;
- Relying as much as possible on packages expected to be present in an average Linux disto _and on Pandoc_;
- Following the KISS principle<sup>[3](#kiss)</sup>

## Dependencies

- Any modern and feature-full shell (developed in ZSH and known to work in BASH);
- GNU Coreutils;
- GNU Grep;
- GNU SED;
- Pandoc;
- JQ.

## Installation

Not required. Just download the files and put them in the right places. Start blogging. If you down't want to run the scripts using a `sh make.sh` command (for instance) you can `chmod 755` each of them, but that's up to you.

## File format

Content must be written in Markdown. All content files must include a [YAML header](https://en.wikipedia.org/wiki/YAML), minimally providing:

````
---
title: "Post title"
date: "2020-08-15"
author: "John Doe"
categories: 
  - "category"
tags: 
  - "tag1"
  - "tag2"
  - "tag3"
  - "tag4"
coverImage: "image.png"
---
````
All items, except `title` are optional for stactic pages and `author` is always optional (unless your blog will have multiple writers).

All values **MUST** be double-quoted. Categories and tags should be in dash lists, with a space between the dash and metadata content.

The `coverImage` is only relevant for the most recent posts, the ones which will appear at the landing page. You can add cover images for every page and post if you like, but the present version has no other use for them.

Without strict adherence to this format, the script will fail.

## Directory structure

- Root/
  - `index.md` : edit this file and write down the greeting text for the landing page.
  - `base.css` : write your stiles in here, the file created by the first run only lists the selectors used in the blog.
  - `recent.txt` : this file is recreated every time the script is run and then included in the home page at the end of the compilation.
  - `pinned.txt` : this file contains a list of your favourite items, which you want to keep in the landing page
  - `make.sh` : **the actual generation script**
  - `catlist.txt` : this file is created by the first run of the script but is never updated automatically. Run `get_cats.sh` manually to repopulate it.
  - `taglist.txt` : this file is created by the first run of the script but is never updated automatically. Run `get_cats.sh` manually to repopulate it.
  - `robots.txt` : this file is recreated every time the script is run. Don't edit.
  - `sitemap.xml` : this file is recreated every time the script is run. Don't edit.
  - `atom.xml` : this file is recreated every time the script is run. Don't edit.
  - `get_cats.sh` : this script must be run before the first run of the script and then whenever you add a new category. Run it manually anytime you want to refresh the category list. If you install a new release of `make.sh`, delete this file so that the script can be recreated, then run it.
  - `get_tags.sh` : this script must be run before the first run of the script and then whenever you add a new tag. Run it periodically to keep the taglist fresh. If you install a new release of `make.sh`, delete this file so that the script can be recreated, then run it.
  - `pages/` : stactic pages go here (HTML 5). You can, in theory, name the source files any way you like it, but I advise you to use short names, as these are the names that will go in your navigation menu.
    - `_index.txt` : this file is generated by script and used to compile the `pages/index.html`
    - `assets/` : images and files linked in the pages you should put here.
  - `posts/` : posts go here (HTML 5). The source files must be named `YYYY-MM-DD-Title.md` in which YYYY means the year, MM the month and DD the day. 
    - `_index.txt` : this file is generated by script and used to compile the `posts/index.html`
    - `images/` : images (but not other files) linked in blog posts should be here.
  - `templates/` : this folder contains the templates Pandoc uses to generate the stactic version.
    - `pages.html` : the template used for stactic pages.
    - `posts.html` : the template used for posts.
    - `sidebar.txt` : edit this file and write your own sidebar content.
    - `masthead.txt` : edit this file and put your side identity and logos.
    - `footer.txt` : edit this file and put your own copyright notice and whatever else.
  - `categories/` : this folder contains subfolders for each category dected during compilation.
    - `_index.txt` : this file is generated by script and used to compile the `categories/index.html`
    - generated category folders/ : each detected category will get a folder with and `_index.txt` (and therefore an `index.html` file.
  - `tags/` : this folder contains subfolders for each tag dected during compilation. If you are a prolific tagger, this can lead to hundreds of subfolders here.
    - `_index.txt` : this file is generated by script and used to compile the `tags/index.html`
    - generated tag folders/ : for each tag, a subdirectory.
- `.htaccess` : provided a basic example, probably unsuitable for you, edit as you need.    

## Building the site

1. Write a good number of posts and stactic pages
2. Run the `get_cats.sh` and the `get_tags.sh` scripts.
3. Run the `make.sh` script.
4. Upload the entire root directory to your host provider.

Please negotiate with your host provider if he can grant you ssh access to do everything on the cloud. Pandoc must be installed and available to you.

Another possibility is to generate a USB stick containing a minimal distribution so you can boot it wherever you go and update your blog.

Blogs with multiple writers are a bit trickier as you will need to set up rsync (which I can't).

## References
<a name="markdown"><sup>1</sup></a> Visit <http://daringfireball.net/projects/markdown> for the original markdown spec. GitHub has its own improved spec here: <https://github.github.com/gfm>

<a name="pandoc"><sup>2</sup></a> Developed by John McFarlane at <https://github.com/jgm/pandoc>. Website at <https://pandoc.org/index.html> 

<a name="kiss"><sup>3</sup></a> <https://people.apache.org/~fhanik/kiss.html>