% BibTeX bibliography style 'toread'
% by David Kotz kotz@dartmouth.edu
% February 2001, March 2019
%    modified from
% BibTeX bibliography style `toread' by dfk
% and BibTeX bibliography style `html-long' by dfk
%    modified from
% BibTeX standard bibliography style `alpha'
   % Version 0.99b (8-Dec-10 release) for BibTeX versions 0.99a or later.
   % Copyright (C) 1984, 1985, 1988, 2010 Howard Trickey and Oren Patashnik.
   % Unlimited copying and redistribution of this file are permitted as long as
   % it is unmodified.  Modifications (and redistribution of modified versions)
   % are also permitted, but only if the resulting file is renamed to something
   % besides btxbst.doc, plain.bst, unsrt.bst, alpha.bst, and abbrv.bst.
   % This restriction helps ensure that all standard styles are identical.
   % The file btxbst.doc has the documentation for this style.

% The 'abstract' section is suited for multi-paragraph abstracts, if
% necessary, but note that bibtex takes out the blank line that you
% might use to indicate a new paragraph.  Use \par where you want a
% new paragraph in an abstract or comment.

% DFK added abstract, articleno, toread, URL
ENTRY
  { abstract
    address
    articleno
    author
    booktitle
    chapter
    DOI
    edition
    editor
    howpublished
    institution
    journal
    key
    keywords
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
    volume
    year
  }
  {}
  { label extra.label sort.label }


INTEGERS { output.state before.all mid.sentence after.sentence after.block }

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

% DFK: use cite$ for the label
% DFK: use HTML, and use URL to make cite key a link
FUNCTION {output.bibitem}
{ 
  newline$
  "<DT>" write$
  choose.URL empty$
    { "<A NAME=" quote$ * cite$ * quote$ * 
	">" * cite$ * "</A>:" * write$
    }
    { "<A NAME=" quote$ * cite$ * quote$ * " HREF=" * quote$ * 
	choose.URL * quote$ * ">" * cite$ * "</A>:" * write$
    }
  if$
  "</DT>" write$
  newline$
  "<DD>" write$ newline$
  ""
  before.all 'output.state :=
}

% DFK changed to HTML
FUNCTION {fin.entry}
{ 
   "</DD>" write$ newline$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
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

% DFK changed to HTML
FUNCTION {emphasize}
{ duplicate$ empty$
    { pop$ "" }
    { "<EM>" swap$ * "</EM>" * }
  if$
}

% DFK added for HTML strong emphasis
FUNCTION {strong}
{ duplicate$ empty$
    { pop$ "" }
    { "<STRONG>" swap$ * "</STRONG>" * }
  if$
}

INTEGERS { nameptr namesleft numnames }

% DFK added this, to strip {} and ~ from titles and authors
% It's not a great idea, because it will screw up in math mode and some
% special characters... but it makes most things much prettier.
FUNCTION {author.title.purify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "{" = 
      t #1 #1 substring$ "}" = or
      	'skip$
	{ t #1 #1 substring$ "~" =
    	    { " " * }
    	    { t #1 #1 substring$ * }
    	if$
    	}
      if$
      t #2 global.max$ substring$ 't :=
    }
  while$
}

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
		{ " et&nbsp;al." * }
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
    { author format.names  author.title.purify }
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

% DFK added strong, so it will be bold.
FUNCTION {format.title}
{ title empty$
    { "" }
    { title "t" change.case$  author.title.purify strong }
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

% DFK changed emphasize to strong
FUNCTION {format.btitle}
{ title author.title.purify strong
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "&nbsp;" }
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

% DFK: print the article number
FUNCTION {format.articleno}
{ articleno empty$
    { "" }
    { "Article #" articleno * }
  if$
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

% DFK: use articleno if available, else pages
FUNCTION {format.articleno.pages}
{ articleno empty$
    { format.pages }
    { format.articleno }
  if$
}

% DFK: add articleno, printing it when available
FUNCTION {format.vol.num.articleno.pages}
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
  % use #articleno if available, :pages if not available
  articleno empty$
    { pages empty$
        'skip$
        { duplicate$ empty$
          { pop$ format.pages }
          { ":" * pages n.dashify * }
          if$
        }
      if$
      }
    { duplicate$ empty$
      { pop$ format.articleno }
      { "#" * articleno * }
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
	{ "In <em>" journal * "</em>" * }
      if$
    }
    { "In " key * }
  if$
  " <a href=#" * crossref * ">[" * crossref * "]</a>" *
}

FUNCTION {format.crossref.editor}
{ editor #1 "{vv~}{ll}" format.name$
  editor num.names$ duplicate$
  #2 >
    { pop$ " et&nbsp;al." * }
    { #2 <
	'skip$
	{ editor #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
	    { " et&nbsp;al." * }
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
	    { "<em>" * series * "</em>" * }
	  if$
	}
	{ key * }
      if$
    }
    { format.crossref.editor * }
  if$
  " <a href=#" * crossref * ">[" * crossref * "]</a>" *
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
	    { "In <em>" booktitle * "</em>" * }
	  if$
	}
	{ "In " key * }
      if$
    }
    { "In " format.crossref.editor * }
  if$
  " <a href=#" * crossref * ">[" * crossref * "]</a>" *
}


% DFK added
% top of stack is the string we want to be a quoted paragraph
FUNCTION {format.quotedParagraph}
{ duplicate$ empty$
    { skip$ }
    { "<P><QUOTE> " swap$ * "  </QUOTE></P>" *}
  if$
}


% DFK added, to support comment, private, keywords, etc
% next-to-top is field name (eg, "Comment")
% top is field value (eg, value of comment)
% both are popped; resulting top is either empty, 
%    or string describing field
FUNCTION {format.dfkfield}
{ duplicate$ empty$
	{ pop$ pop$ "" }
	{ swap$ 
          "<strong> " swap$ * ":</strong> " * swap$ * }
  if$
}

STRINGS { checked }

% DFK added
FUNCTION {output.radio}
{
  duplicate$

  % at this point the stack should contain
  %  value
  %  value

  duplicate$ checked =
    {" checked" * }
    { skip$ }
  if$

  % at this point the stack should contain either the 
  %  value
  %  value
  % or
  %  value " checked"
  %  value

  "<input type=radio name=" cite$ * " value=" *
  swap$ *
  ">&nbsp;" *
  swap$ *
  "&nbsp;&nbsp;" *
  write$
}


% DFK added
FUNCTION {dfk.form.stuff}
{ 
  newline$
  "<p>" write$
  toread empty$
    { "0" 'checked := }
    { toread 'checked := }
  if$
  "<b>Priority:</b>&nbsp;&nbsp;" write$
  "0" output.radio
  "1" output.radio
  "2" output.radio
  "3" output.radio
  "4" output.radio
  "5" output.radio
  "6" output.radio
  "7" output.radio
  "8" output.radio
  "9" output.radio
  "99" output.radio
  "x" output.radio
  newline$
  "</p>" write$
}

% DFK added
FUNCTION {dfk.stuff}
{ 
  add.period$
  write$
  newline$

  dfk.form.stuff

  new.block
  "Abstract" abstract format.dfkfield format.quotedParagraph write$ newline$
}

% DFK: added a call to dfk.stuff in all entry-type functions below

FUNCTION {article}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  crossref missing$
    { journal emphasize "journal" output.check
      format.vol.num.articleno.pages output
      format.date "year" output.check
    }
    { format.article.crossref output.nonnull
      format.articleno.pages output
    }
  if$
  format.DOI output
  new.block
  note output
  dfk.stuff
  fin.entry
}

FUNCTION {book}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull
      crossref missing$
	{ "author and editor" editor either.or.check }
	'skip$
      if$
    }
  if$
  new.block
  format.btitle "title" output.check
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
  new.block
  note output
  dfk.stuff
  fin.entry
}

FUNCTION {booklet}
{ output.bibitem
  format.authors output
  new.block
  format.title "title" output.check
  howpublished address new.block.checkb
  howpublished output
  address output
  format.date output
  format.DOI output
  new.block
  note output
  dfk.stuff
  fin.entry
}

FUNCTION {inbook}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull
      crossref missing$
	{ "author and editor" editor either.or.check }
	'skip$
      if$
    }
  if$
  new.block
  format.btitle "title" output.check
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
  new.block
  note output
  dfk.stuff
  fin.entry
}

FUNCTION {incollection}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
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
  new.block
  note output
  dfk.stuff
  fin.entry
}

FUNCTION {inproceedings}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output
      format.articleno.pages output
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
      format.articleno.pages output
    }
  if$
  format.DOI output
  new.block
  note output
  dfk.stuff
  fin.entry
}

FUNCTION {conference} { inproceedings }

FUNCTION {manual}
{ output.bibitem
  author empty$
    { organization empty$
	'skip$
	{ organization output.nonnull
	  address output
	}
      if$
    }
    { format.authors output.nonnull }
  if$
  new.block
  format.btitle "title" output.check
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
  new.block
  note output
  dfk.stuff
  fin.entry
}

FUNCTION {mastersthesis}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  "Master's thesis" format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.date "year" output.check
  format.DOI output
  new.block
  note output
  dfk.stuff
  fin.entry
}

FUNCTION {misc}
{ output.bibitem
  format.authors output
  title howpublished new.block.checkb
  format.title output
  howpublished new.block.checka
  howpublished output
  format.date output
  format.DOI output
  new.block
  note output
  dfk.stuff
  fin.entry
  empty.misc.check
}

FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.btitle "title" output.check
  new.block
  "PhD thesis" format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.date "year" output.check
  format.DOI output
  new.block
  note output
  dfk.stuff
  fin.entry
}

FUNCTION {proceedings}
{ output.bibitem
  editor empty$
    { organization output }
    { format.editors output.nonnull }
  if$
  new.block
  format.btitle "title" output.check
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
  new.block
  note output
  dfk.stuff
  fin.entry
}

FUNCTION {techreport}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  format.tr.number output.nonnull
  institution "institution" output.check
  address output
  format.date "year" output.check
  format.DOI output
  new.block
  note output
  dfk.stuff
  fin.entry
}

FUNCTION {unpublished}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  format.DOI output
  new.block
  note "note" output.check
  format.date output
  dfk.stuff
  fin.entry
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

FUNCTION {presort}
{
% DFK use toread and cite$ for sort key
  toread empty$
    { "" }
    { toread cite$ * }
  if$
  'sort.key$ :=
}

ITERATE {presort}

SORT

FUNCTION {begin.bib}
{ 
 "<HTML>" write$ newline$
  "<HEAD><TITLE> To-be-read listing </TITLE></HEAD>" write$ newline$
  "<BODY BGCOLOR=#EEEEEE>" write$ newline$
  "<h1>To be read</h1>" write$ newline$
  "0=unassigned, 1-9 decreasing priority, 99=never read, x=delete" write$
  "<form action=updatetoread.cgi method=POST>" write$
  "<input type=submit value=Submit> updates to priorities" write$
  "<DL>" write$ newline$
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "</DL>" write$ newline$
  "<p>" write$ newline$
  "<input type=submit value=Submit> updates to priorities" write$ newline$
  "</form>" write$ newline$
  "</BODY>" write$ newline$
  "</HTML>" write$ newline$
}

EXECUTE {end.bib}
