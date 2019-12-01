# BibTeX style files

As modified and maintained by David Kotz.

Three main categories: 

* `subset-*` produce a bibtex file that is a subset of the source bibtex
* `*DOI.bst` produce a latex References section much like the standard styles but with smarts to support DOI and URL fields.
* `plainDOImend.bst` incorporates special 'fixes' to deal with Mendeley exports.  
	* TODO: merge this into `plainDOI` permanently, and add the same capability to other `*DOI.bst` as well.


## Reference material

Some of which is cached in subdirectory `documentation`.

* [BibTeX CTAN distribution](https://ctan.org/pkg/bibtex), notably, the original author's documentation:
  * [using BibTeX](http://mirrors.ctan.org/biblio/bibtex/base/btxdoc.pdf) - for those writing bib files
  * [writing BibTeX styles](http://mirrors.ctan.org/biblio/bibtex/base/btxhak.pdf) - for those writing bst files
* [TameTheBeast](https://ctan.org/pkg/tamethebeast) - a manual that goes beyond the original documentation. No need to download the package - just click the pdf link.
* [How to do search-and-replace in BibTeX](https://tex.stackexchange.com/questions/28102/use-character-substitution-in-bibtex-bst-file)

## IEEE styles

**IEEEtran** for conferences and journals:

* IEEEtran.bst should already be available in standard TeX distros.
	*  `/usr/local/texlive/2018/texmf-dist/bibtex//bst/IEEEtran/IEEEtran.bst`
* As of November 2019, it is at v1.14, per [info](http://www.michaelshell.org/tex/ieeetran/) from its maintainer.
* other distributions are behind, e.g., IEEE distributes v1.12.

## ACM styles

***coming soon...***

## To do

* support ACM style
* port Mendeley fixes from `plainDOImend` to all other DOI styles.
* consider a new bst that is more concise, as our new default.
  * (show DOI instead of vol, num, pages, month)
  * (warn if no DOI for article, inproc, incoll)
