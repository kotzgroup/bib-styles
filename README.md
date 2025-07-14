# BibTeX style files

As modified and maintained by David Kotz.

Three main categories: 

* `subset-*` produce a bibtex file that is a subset of the source bibtex
* `*DOI.bst` produce a latex References section much like the standard styles but with smarts to support DOI and URL fields.
* `ACM.bst` incorporates special 'fixes' to deal with Mendeley exports.  It natively handles DOI.
* `plainDOI.bst` incorporates special 'fixes' to deal with Mendeley exports.

## Reference material

Some of which is cached in subdirectory `documentation`.

* [BibTeX CTAN distribution](https://ctan.org/pkg/bibtex), notably, the original author's documentation:
  * [using BibTeX](http://mirrors.ctan.org/biblio/bibtex/base/btxdoc.pdf) - for those writing bib files
  * [writing BibTeX styles](http://mirrors.ctan.org/biblio/bibtex/base/btxhak.pdf) - for those writing bst files
* [TameTheBeast](https://ctan.org/pkg/tamethebeast) - a manual that goes beyond the original documentation. No need to download the package - just click the pdf link.
* [How to do search-and-replace in BibTeX](https://tex.stackexchange.com/questions/28102/use-character-substitution-in-bibtex-bst-file)

## Reference styles

See `base/README.md` for a cached copy of the styles from which mine are derived, and information about where and when I obtained them.

## To do

* consider a new bst that is more concise, as our new default.
  * (show DOI instead of vol, num, pages, month)
  * (warn if no DOI for article, inproc, incoll)
