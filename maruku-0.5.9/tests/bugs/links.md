Write a comment here
*** Parameters: ***
{} # params 
*** Markdown input: ***
Amazing [Museo].
 
  [Museo]: <http://www.josbuivenga.demon.nl/museo.html> (Jos Buivenga's Museo free typeface)

*** Output of inspect ***
md_el(:document,[
	md_par(["Amazing ", md_link(["Museo"],"museo"), "."]),
	md_ref_def("museo", "http://www.josbuivenga.demon.nl/museo.html", {:title=>"Jos Buivenga"})
],{},[])
*** Output of to_html ***
<p>Amazing <a href='http://www.josbuivenga.demon.nl/museo.html' title='Jos Buivenga'>Museo</a>.</p>
*** Output of to_latex ***
Amazing \href{http://www.josbuivenga.demon.nl/museo.html>}{Museo}.
*** Output of to_md ***
Amazing Museo.
*** Output of to_s ***
Amazing Museo.
*** EOF ***




Failed tests:   [:to_latex] 

*** Output of inspect ***
md_el(:document,[
	md_par(["Amazing ", md_link(["Museo"],"museo"), "."]),
	md_ref_def("museo", "http://www.josbuivenga.demon.nl/museo.html", {:title=>"Jos Buivenga"})
],{},[])
*** Output of to_html ***
<p>Amazing <a href='http://www.josbuivenga.demon.nl/museo.html' title='Jos Buivenga'>Museo</a>.</p>
*** Output of to_latex ***
-----| WARNING | -----
Amazing \href{http://www.josbuivenga.demon.nl/museo.html}{Museo}.
*** Output of to_md ***
Amazing Museo.
*** Output of to_s ***
Amazing Museo.
*** Output of Markdown.pl ***
<p>Amazing [Museo].</p>

*** Output of Markdown.pl (parsed) ***
Error: #<NoMethodError: private method `write_children' called for <div> ... </>:REXML::Element>
