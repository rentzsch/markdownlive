Write a comment here
*** Parameters: ***
{} # params 
*** Markdown input: ***
a < b

*** Output of inspect ***
md_el(:document,[md_par(["a < b"])],{},[])
*** Output of to_html ***
<p>a &lt; b</p>
*** Output of to_latex ***
a {\tt \char60} b
*** Output of to_md ***
a < b
*** Output of to_s ***
a < b
*** EOF ***



	OK!



*** Output of Markdown.pl ***
<p>a &lt; b</p>

*** Output of Markdown.pl (parsed) ***
Error: #<NoMethodError: private method `write_children' called for <div> ... </>:REXML::Element>
