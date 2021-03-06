% BibTeX bibliography style `pages
% by David Kotz kotz@cs.dartmouth.edu
% Jan 2002
%   This prints the bibliography using macros suitable for printing one
% reference per page.
% $Id: pages.bst,v 1.1.1.1 2002/09/12 19:38:00 dfk Exp $
%  modified from
   % BibTeX bibliography style `html-short' 
   %   spits out HTML-formatted bibliography in place of bbl output
   % by David Kotz kotz@cs.dartmouth.edu
   %    modified from
        % BibTeX standard bibliography style `alpha'
   	% version 0.99a for BibTeX versions 0.99a or later, LaTeX version 2.09.
	% Copyright (C) 1985, all rights reserved.
	% Copying of this file is authorized only if either
	% (1) you make absolutely no changes to your copy, including name, or
	% (2) if you do make changes, you name it something other than
	% btxbst.doc, plain.bst, unsrt.bst, alpha.bst, and abbrv.bst.
	% This restriction helps ensure that all standard styles are identical.
	% The file btxbst.doc has the documentation for this style.

ENTRY
  { abstract
    address
    author
    booktitle
    chapter
    comment
    DOI
    earlier
    edition
    editor
    howpublished
    institution
    identical
    journal
    key
    later
    month
    note
    number
    organization
    pages
    publisher
    school
    series
    title
    type
    URL
    URLpdf
    volume
    year
  }
  {}
  { label extra.label sort.label }

INTEGERS { output.state before.all mid.sentence after.sentence after.block}

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
}

STRINGS { s t }

FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    { ", " * write$ }
    { output.state after.block =
	{ add.period$ write$
	  newline$
	}
	{ output.state before.all =
	     'write$
	     { add.period$ " " * write$ }
	    if$
	}
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}

% DFK added; write out in brackets.  input is nonnull
FUNCTION {write.bracketed.nonnull}
{ 
  "{" write$
      write$
  "}" write$
}

% DFK added; write out in brackets if not empty
FUNCTION {write.bracketed}
{ 
  duplicate$ empty$ 
    'pop$
    'write.bracketed.nonnull
  if$
}

% DFK added; warn if empty, else write out in brackets
FUNCTION {write.bracketed.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    { write.bracketed }
  if$
}

% DFK made 
FUNCTION {begin.item}
{ newline$
  "\paper{" cite$ * "}" * write$
  before.all 'output.state :=
}

% DFK made 
FUNCTION {end.item}
{ newline$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}

FUNCTION {fin.block}
{ add.period$
  write$
  before.all 'output.state :=
}

FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
	'skip$
	{ after.sentence 'output.state := }
      if$
    }
  if$
}

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

FUNCTION {new.block.checka}
{ empty$
    'skip$
    'new.block
  if$
}

FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.block
  if$
}

FUNCTION {new.sentence.checka}
{ empty$
    'skip$
    'new.sentence
  if$
}

FUNCTION {new.sentence.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.sentence
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {emphasize}
{ duplicate$ empty$
    { pop$ "" }
    { "\emph{" swap$ * "}" * }
  if$
}

INTEGERS { nameptr namesleft numnames }

FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{ff~}{vv~}{ll}{, jj}" format.name$ 't :=
      nameptr #1 >
	{ namesleft #1 >
	    { ", " * t * }
	    { numnames #2 >
		{ "," * }
		'skip$
	      if$
	      t "others" =
		{ " et~al." * }
		{ " and " * t * }
	      if$
	    }
	  if$
	}
	't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.authors}
{ author empty$
    { "" }
    { author format.names  }
  if$
}

FUNCTION {format.editors}
{ editor empty$
    { "" }
    { editor format.names
      editor num.names$ #1 >
	{ ", editors" * }
	{ ", editor" * }
      if$
    }
  if$
}

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

FUNCTION {format.title}
{ title empty$
    { "" }
    { title "t" change.case$ }
  if$
}

FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
	{ t #1 #2 substring$ "--" = not
	    { "--" *
	      t #2 global.max$ substring$ 't :=
	    }
	    {   { t #1 #1 substring$ "-" = }
		{ "-" *
		  t #2 global.max$ substring$ 't :=
		}
	      while$
	    }
	  if$
	}
	{ t #1 #1 substring$ *
	  t #2 global.max$ substring$ 't :=
	}
      if$
    }
  while$
}

FUNCTION {format.date}
{ year empty$
    { month empty$
	{ "" }
	{ "there's a month but no year in " cite$ * warning$
	  month
	}
      if$
    }
    { month empty$
	'year
	{ month " " * year * }
      if$
    }
  if$
}

FUNCTION {format.btitle}
{ title  
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

FUNCTION {format.bvolume}
{ volume empty$
    { "" }
    { "volume" volume tie.or.space.connect
      series empty$
	'skip$
	{ " of " * series emphasize * }
      if$
      "volume and number" number either.or.check
    }
  if$
}

FUNCTION {format.number.series}
{ volume empty$
    { number empty$
	{ series field.or.null }
	{ output.state mid.sentence =
	    { "number" }
	    { "Number" }
	  if$
	  number tie.or.space.connect
	  series empty$
	    { "there's a number but no series in " cite$ * warning$ }
	    { " in " * series * }
	  if$
	}
      if$
    }
    { "" }
  if$
}

FUNCTION {format.edition}
{ edition empty$
    { "" }
    { output.state mid.sentence =
	{ edition "l" change.case$ " edition" * }
	{ edition "t" change.case$ " edition" * }
      if$
    }
  if$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
	{ #1 'multiresult := }
	{ t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages multi.page.check
	{ "pages" pages n.dashify tie.or.space.connect }
	{ "page" pages tie.or.space.connect }
      if$
    }
  if$
}

FUNCTION {format.vol.num.pages}
{ volume field.or.null
  number empty$
    'skip$
    { "(" number * ")" * *
      volume empty$
	{ "there's a number but no volume in " cite$ * warning$ }
	'skip$
      if$
    }
  if$
  pages empty$
    'skip$
    { duplicate$ empty$
	{ pop$ format.pages }
	{ ":" * pages n.dashify * }
      if$
    }
  if$
}

FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
	{ "chapter" }
	{ type "l" change.case$ }
      if$
      chapter tie.or.space.connect
      pages empty$
	'skip$
	{ ", " * format.pages * }
      if$
    }
  if$
}

FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
    { "" }
    { editor empty$
	{ "In " booktitle emphasize * }
	{ "In " format.editors * ", " * booktitle emphasize * }
      if$
    }
  if$
}

FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and
  key empty$ not and
    { "all relevant fields are empty in " cite$ * warning$ }
    'skip$
  if$
}

FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      type "t" change.case$
    }
  if$
}

FUNCTION {format.tr.number}
{ type empty$
    { "Technical Report" }
    'type
  if$
  number empty$
    { "t" change.case$ }
    { number tie.or.space.connect }
  if$
}

FUNCTION {format.article.crossref}
{ key empty$
    { journal empty$
	{ "need key or journal for " cite$ * " to crossref " * crossref *
	  warning$
	  ""
	}
	{ "In \emph{" journal * "}" * }
      if$
    }
    { "In " key * }
  if$
  " \ref{" * crossref * "}" *
}

FUNCTION {format.crossref.editor}
{ editor #1 "{vv~}{ll}" format.name$
  editor num.names$ duplicate$
  #2 >
    { pop$ " et~al." * }
    { #2 <
	'skip$
	{ editor #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
	    { " et~al." * }
	    { " and " * editor #2 "{vv~}{ll}" format.name$ * }
	  if$
	}
      if$
    }
  if$
}

FUNCTION {format.book.crossref}
{ volume empty$
    { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
      "In "
    }
    { "Volume" volume tie.or.space.connect
      " of " *
    }
  if$
  editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
	{ series empty$
	    { "need editor, key, or series for " cite$ * " to crossref " *
	      crossref * warning$
	      "" *
	    }
	    { "\emph{" * series * "}" * }
	  if$
	}
	{ key * }
      if$
    }
    { format.crossref.editor * }
  if$
  " \ref{" * crossref * "}" *
}

FUNCTION {format.incoll.inproc.crossref}
{ editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
	{ booktitle empty$
	    { "need editor, key, or booktitle for " cite$ * " to crossref " *
	      crossref * warning$
	      ""
	    }
	    { "In \emph{" booktitle * "}" * }
	  if$
	}
	{ "In " key * }
      if$
    }
    { "In " format.crossref.editor * }
  if$
  " \ref{" * crossref * "}" *
}


% CUSTOMIZE: DFK added
FUNCTION {format.earlier}
{
   earlier empty$
     { "" }
     { "Revision of \ref{" earlier * "}" * }
   if$
}

% CUSTOMIZE: DFK added
FUNCTION {format.identical}
{
   identical empty$
     { "" }
     { "Identical to \ref{" identical * "}" * }
   if$
}

% CUSTOMIZE: DFK added
FUNCTION {format.later}
{
   later empty$
     { "" }
     { "Later revised as \ref{" later * "}" * }
   if$
}

FUNCTION {format.abstract}
{
   abstract empty$
     { "" }
     { abstract }
   if$
}

FUNCTION {format.comment}
{
   comment empty$
     { "" }
     { comment }
   if$
}

% DFK for debugging; prints output state and comment string on top of stack
% pop and print the whole stack:   stack$
% pop and print the top of the stack:   top$
FUNCTION {show.state}
{
  output.state #48 + int.to.chr$ ": " * 
  swap$ * warning$
}

FUNCTION {article}
{ begin.item
  format.authors "author" write.bracketed.check
  format.title "title" write.bracketed.check
  "{" % leave on the stack, it will get printed by output.nonnull eventually
  crossref missing$
    { 
      journal emphasize "journal" output.check
      format.vol.num.pages output
      format.date "year" output.check
    }
    { format.article.crossref output.nonnull
      format.pages output
    }
  if$
  format.DOI output
  new.sentence
  note output
  new.sentence
  format.identical output
  new.sentence
  format.earlier output
  new.sentence
  format.later output
  new.sentence
  fin.block
  "}" write$ 
  "{" format.abstract * "}" * write$
  "{" format.comment * "}" * write$ newline$
  end.item
}

FUNCTION {book}
{ begin.item
  author empty$
    { format.editors "author and editor" write.bracketed.check }
    { format.authors write.bracketed.nonnull
      crossref missing$
	{ "author and editor" editor either.or.check }
	'skip$
      if$
    }
  if$
  format.btitle "title" write.bracketed.check
  "{"  % output later by output.nonnull
  crossref missing$
    { format.bvolume output
      new.block
      format.number.series output
      new.sentence
      publisher "publisher" output.check
      address output
    }
    { new.block
      format.book.crossref output.nonnull
    }
  if$
  format.edition output
  format.date "year" output.check
  format.DOI output
  new.sentence
  note output
  new.sentence
  format.identical output
  new.sentence
  format.earlier output
  new.sentence
  format.later output
  fin.block
  "}" write$ 
  "{" format.abstract * "}" * write$
  "{" format.comment * "}" * write$ newline$
  end.item
}

FUNCTION {booklet}
{ begin.item
  format.authors output
  format.title "title" write.bracketed.check
  "{"  % output later by output.nonnull
  howpublished address new.block.checkb
  howpublished output
  address output
  format.date output
  format.DOI output
  new.sentence
  note output
  new.sentence
  format.identical output
  new.sentence
  format.earlier output
  new.sentence
  format.later output
  fin.block
  "}" write$ 
  "{" format.abstract * "}" * write$
  "{" format.comment * "}" * write$ newline$
  end.item
}

FUNCTION {inbook}
{ begin.item
  author empty$
    { format.editors "author and editor" write.bracketed.check }
    { format.authors write.bracketed.nonnull
      crossref missing$
	{ "author and editor" editor either.or.check }
	'skip$
      if$
    }
  if$
  format.btitle "title" write.bracketed.check
  "{"  % output later by output.nonnull
  crossref missing$
    { format.bvolume output
      format.chapter.pages "chapter and pages" output.check
      new.block
      format.number.series output
      new.sentence
      publisher "publisher" output.check
      address output
    }
    { format.chapter.pages "chapter and pages" output.check
      new.block
      format.book.crossref output.nonnull
    }
  if$
  format.edition output
  format.date "year" output.check
  format.DOI output
  new.sentence
  note output
  new.sentence
  format.identical output
  new.sentence
  format.earlier output
  new.sentence
  format.later output
  new.sentence
  fin.block
  "}" write$ 
  "{" format.abstract * "}" * write$
  "{" format.comment * "}" * write$ newline$
  end.item
}

FUNCTION {incollection}
{ begin.item

  format.authors "author" write.bracketed.check
  format.title "title" write.bracketed.check
  "{"  % output later by output.nonnull
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output
      format.chapter.pages output
      new.sentence
      publisher "publisher" output.check
      address output
      format.edition output
      format.date "year" output.check
    }
    { format.incoll.inproc.crossref output.nonnull
      format.chapter.pages output
    }
  if$
  format.DOI output
  new.sentence
  note output
  new.sentence
  format.identical output
  new.sentence
  format.earlier output
  new.sentence
  format.later output
  new.sentence
  fin.block
  "}" write$ 
  "{" format.abstract * "}" * write$
  "{" format.comment * "}" * write$ newline$
  end.item
}

FUNCTION {inproceedings}
{ begin.item
  format.authors "author" write.bracketed.check
  format.title "title" write.bracketed.check
  "{"  % output later by output.nonnull
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output
      format.pages output
      address empty$
	{ organization publisher new.sentence.checkb
	  organization output
	  publisher output
	  format.date "year" output.check
	}
	{ address output.nonnull
	  format.date "year" output.check
	  new.sentence
	  organization output
	  publisher output
	}
      if$
    }
    { format.incoll.inproc.crossref output.nonnull
      format.pages output
    }
  if$
  format.DOI output
  new.sentence
  note output
  new.sentence
  format.identical output
  new.sentence
  format.earlier output
  new.sentence
  format.later output
  new.sentence
  fin.block
  "}" write$ 
  "{" format.abstract * "}" * write$
  "{" format.comment * "}" * write$ newline$
  end.item
}

FUNCTION {conference} { inproceedings }

FUNCTION {manual}
{ begin.item

  author empty$
    { organization empty$
	'skip$
	{ organization output.nonnull
	  address output
	}
      if$
    }
    { format.authors write.bracketed.nonnull }
  if$
  format.btitle "title" write.bracketed.check
  "{"  % output later by output.nonnull
  author empty$
    { organization empty$
	{ address new.block.checka
	  address output
	}
	'skip$
      if$
    }
    { organization address new.block.checkb
      organization output
      address output
    }
  if$
  format.edition output
  format.date output
  format.DOI output
  new.sentence
  note output
  new.sentence
  format.identical output
  new.sentence
  format.earlier output
  new.sentence
  format.later output
  fin.block
  "}" write$ 
  "{" format.abstract * "}" * write$
  "{" format.comment * "}" * write$ newline$
  end.item
}

FUNCTION {mastersthesis}
{ begin.item
  format.authors "author" write.bracketed.check
  format.title "title" write.bracketed.check
  "{"  % output later by output.nonnull
  "Master's thesis" format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.date "year" output.check
  format.DOI output
  new.sentence
  note output
  new.sentence
  format.identical output
  new.sentence
  format.earlier output
  new.sentence
  format.later output
  fin.block
  "}" write$ 
  "{" format.abstract * "}" * write$
  "{" format.comment * "}" * write$ newline$
  end.item
}

FUNCTION {misc}
{ begin.item
  format.authors write.bracketed
  title howpublished new.block.checkb
  format.title write.bracketed
  "{"  % output later by output.nonnull
  howpublished new.block.checka
  howpublished output
  format.date output
  format.DOI output
  new.sentence
  note output
  new.sentence
  format.identical output
  new.sentence
  format.earlier output
  new.sentence
  format.later output
  fin.block
  "}" write$ 
  "{" format.abstract * "}" * write$
  "{" format.comment * "}" * write$ newline$
   empty.misc.check
  end.item
}

FUNCTION {phdthesis}
{ begin.item
  format.authors "author" write.bracketed.check
  format.btitle "title" write.bracketed.check
  "{"  % output later by output.nonnull
  "PhD thesis" format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.date "year" output.check
  format.DOI output
  new.sentence
  note output
  new.sentence
  format.identical output
  new.sentence
  format.earlier output
  new.sentence
  format.later output
  fin.block
  "}" write$ 
  "{" format.abstract * "}" * write$
  "{" format.comment * "}" * write$ newline$
  end.item
}

FUNCTION {proceedings}
{ begin.item
  editor empty$
    { organization output }
    { format.editors write.bracketed.nonnull }
  if$
  format.btitle "title" write.bracketed.check
  "{"  % output later by output.nonnull
  format.bvolume output
  format.number.series output
  address empty$
    { editor empty$
	{ publisher new.sentence.checka }
	{ organization publisher new.sentence.checkb
	  organization output
	}
      if$
      publisher output
      format.date "year" output.check
    }
    { address output.nonnull
      format.date "year" output.check
      new.sentence
      editor empty$
	'skip$
	{ organization output }
      if$
      publisher output
    }
  if$
  format.DOI output
  new.sentence
  note output
  new.sentence
  format.identical output
  new.sentence
  format.earlier output
  new.sentence
  format.later output
  fin.block
  "}" write$ 
  "{" format.abstract * "}" * write$
  "{" format.comment * "}" * write$ newline$
  end.item
}

FUNCTION {techreport}
{ begin.item
  format.authors "author" write.bracketed.check
  format.title "title" write.bracketed.check
  "{"  % output later by output.nonnull
  format.tr.number output.nonnull
  institution "institution" output.check
  address output
  format.date "year" output.check
  format.DOI output
  new.sentence
  note output
  new.sentence
  format.identical output
  new.sentence
  format.earlier output
  new.sentence
  format.later output
  fin.block
  "}" write$ 
  "{" format.abstract * "}" * write$
  "{" format.comment * "}" * write$ newline$
  end.item
}

FUNCTION {unpublished}
{ begin.item
  format.authors "author" write.bracketed.check
  format.title "title" write.bracketed.check
  format.DOI output
  "{"  % output later by output.nonnull
  note "note" output.check
  format.date output
  new.sentence
  format.identical output
  new.sentence
  format.earlier output
  new.sentence
  format.later output
  fin.block
  "}" write$ 
  "{" format.abstract * "}" * write$
  "{" format.comment * "}" * write$ newline$
  end.item
}

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



READ

% DFK use cite key for sort
FUNCTION {presort}
{
  cite$
  #1 entry.max$ substring$
  'sort.key$ :=
}

ITERATE {presort}

SORT

FUNCTION {begin.bib}
{ 
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
}

EXECUTE {end.bib}
