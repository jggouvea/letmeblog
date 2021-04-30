# `letmeblog`
A static blog compiler made purely in shell scripting, using 
[Markdown](http://markdownguide.org) as the source format and
[Pandoc](http://www.pandoc.org) as the backend, with the help 
of [GNU Coreutils](https://www.gnu.org/software/coreutils/coreutils.html).

Directly inspired by [Jilles van Gurp](https://github.com/jillesvangurp/www.jillesvangurp.com),
who was the first (afaik) to use custom `bash` scripts to evoke 
Pandoc and build a static site from a set of Markdown files 
exported from Wordpress.

## Implemented features
- Posts (content sorted by date)
- Pages (fixed content)
- Feed (in Atom format)
- Sitemap (in XML format)
- Categories & Tags (with their respective index pages)
- Archives page
- "Before" and "After" links in post footer
- Pinned post
- Landing page with recent posts

## Planned features
- Use `gpp` to improve source processing
- Build ebooks and printable books from anthologies of 
  posts
- Automated FTP upload
- Code cleanup for speed
- Makefile (for those of you who like automation, unlike me)
- Comment system
- Some kind of local post search
- Better handling of figure environments and embedded video
- Improving user experience with `.htaccess`
- SEO using `robots.txt`

## Design goals

- Recreate the most usual (and useful) features of Wordpress;
- Requiring the least possible amount of dependencies;
- Relying as much as possible on packages expected to be present
  in an average Linux disto _and on Pandoc_;
- The [KISS](https://people.apache.org/~fhanik/kiss.html) principle;
- [POG](https://fernandofranzini.wordpress.com/2012/07/11/pog-programacao-orientada-a-gambiarras) 
  ([Programação Orientada a Gambiarras](https://desciclo.pedia.ws/wiki/Programação_Orientada_a_Gambiarras)),
  also known as [WOP](https://en.uncyclopedia.co/wiki/Workaround-oriented_programming)
  if you are an English speaker.
  
## Dependencies

- A modern shell (developed in ZSH, known to work in BASH);
- GNU Coreutils;
- GNU Grep;
- GNU SED;
- Pandoc;
- JQ;
- [GPP](https://files.nothingisreal.com/software/gpp) (only for
  documentation parsing, not actually required to build the
  website/blog).

## Installation

Not required. Just download the files and put them in the right 
places. Start writing rightaway and build the blog in modules,
by running each script separately _and sequentially_. Upload to
server using an FTP client, like `lftp`.

## Usage
See detailed information in the [`letmedoc`](letmedoc.html) file
before you start. A five minute read that has everything you need
to build yourself a \[mostly\] functional blog.


