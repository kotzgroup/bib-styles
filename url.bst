% BibTeX bibliography style `url'
% by David Kotz kotz@dartmouth.edu
% August 2002
%   This prints just the cite key and the URL for each paper that has
% a URL.  If DOI or URLpdf exists, it is preferred over URL.
% modified from 
  % BibTeX bibliography style `subset'
  % by David Kotz kotz@dartmouth.edu
  % August 1992, May 1993, February 1999
  % modified from 
   %  BibTeX standard bibliography style `alpha'
   % Version 0.99b (8-Dec-10 release) for BibTeX versions 0.99a or later.
   % Copyright (C) 1984, 1985, 1988, 2010 Howard Trickey and Oren Patashnik.
   % Unlimited copying and redistribution of this file are permitted as long as
   % it is unmodified.  Modifications (and redistribution of modified versions)
   % are also permitted, but only if the resulting file is renamed to something
   % besides btxbst.doc, plain.bst, unsrt.bst, alpha.bst, and abbrv.bst.
   % This restriction helps ensure that all standard styles are identical.
   % The file btxbst.doc has the documentation for this style.

% DFK added abstract, comment, DOI, keywords, URL, URLpdf
ENTRY
  { acceptpercent
    abstract
    address
    author
    booktitle    
    category
    chapter
    comment
    copyright
    DOI
    earlier
    edition
    editor
    howpublished
    identical
    institution
    journal
    key
    keywords
    later
    month
    note
    number
    organization
    pages
    private
    publisher
    school
    series
    title
    toread
    type
    URL
    URLpdf
    vitanote
    vitatype 
    volume
    year
  }
  {}
  { label extra.label sort.label }

STRINGS { s t }

% DFK added to pick the best URL, if none return ""
% use URLpdf if available, otherwise DOI, otherwise URL
FUNCTION {choose.URL}
{
  URLpdf missing$
    {
	DOI missing$
	{	URL missing$
		    { "" }
		    { URL }
		if$
	}
	{
		"http://dx.doi.org/" DOI *
	}
	if$
    }
    {
	URLpdf
    }
  if$
}

% CUSTOMIZE: DFK added
FUNCTION {format.DOI}
{
   DOI empty$
     { "" }
     { "DOI " DOI * }
   if$
}

% doesn't always write something
FUNCTION {output.bibitem}
{
  choose.URL empty$
     'skip$
    { cite$ "	" * choose.URL * write$ newline$ }
  if$
  pop$
}

FUNCTION {article}{ "Article" output.bibitem }

FUNCTION {book}{ "Book" output.bibitem }

FUNCTION {booklet}{ "Booklet" output.bibitem }

FUNCTION {inbook}{ "InBook" output.bibitem }

FUNCTION {incollection}{ "InCollection" output.bibitem }

FUNCTION {inproceedings}{ "InProceedings" output.bibitem }

FUNCTION {conference}{ "Conference" output.bibitem }

FUNCTION {manual}{ "Manual" output.bibitem }

FUNCTION {mastersthesis}{ "MastersThesis" output.bibitem }

FUNCTION {misc}{ "Misc" output.bibitem }

FUNCTION {phdthesis}{ "PhdThesis" output.bibitem }

FUNCTION {proceedings}{ "Proceedings" output.bibitem }

FUNCTION {techreport}{ "TechReport" output.bibitem }

FUNCTION {unpublished}{ "Unpublished" output.bibitem }

FUNCTION {default.type} { misc }

MACRO {jan} {"January"}

MACRO {feb} {"February"}

MACRO {mar} {"March"}

MACRO {apr} {"April"}

MACRO {may} {"May"}

MACRO {jun} {"June"}

MACRO {jul} {"July"}

MACRO {aug} {"August"}

MACRO {sep} {"September"}

MACRO {oct} {"October"}

MACRO {nov} {"November"}

MACRO {dec} {"December"}

MACRO {acmcs} {"ACM Computing Surveys"}

MACRO {acta} {"Acta Informatica"}

MACRO {cacm} {"Communications of the ACM"}

MACRO {ibmjrd} {"IBM Journal of Research and Development"}

MACRO {ibmsj} {"IBM Systems Journal"}

MACRO {ieeese} {"IEEE Transactions on Software Engineering"}

MACRO {ieeetc} {"IEEE Transactions on Computers"}

MACRO {ieeetcad}
 {"IEEE Transactions on Computer-Aided Design of Integrated Circuits"}

MACRO {ipl} {"Information Processing Letters"}

MACRO {jacm} {"Journal of the ACM"}

MACRO {jcss} {"Journal of Computer and System Sciences"}

MACRO {scp} {"Science of Computer Programming"}

MACRO {sicomp} {"SIAM Journal on Computing"}

MACRO {tocs} {"ACM Transactions on Computer Systems"}

MACRO {tods} {"ACM Transactions on Database Systems"}

MACRO {tog} {"ACM Transactions on Graphics"}

MACRO {toms} {"ACM Transactions on Mathematical Software"}

MACRO {toois} {"ACM Transactions on Office Information Systems"}

MACRO {toplas} {"ACM Transactions on Programming Languages and Systems"}

MACRO {tcs} {"Theoretical Computer Science"}

READ

% DFK use cite$ for sort key
FUNCTION {presort}
{
  cite$
  #1 entry.max$ substring$
  'sort.key$ :=
}

ITERATE {presort}

SORT

ITERATE {call.type$}
