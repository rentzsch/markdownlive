Write a comment here
*** Parameters: ***
{} # params 
*** Markdown input: ***

I would like to add a syntax for drawing basic diagrams
and convert them to PNG/PDF/SVG.


	+----------+      +----------+
	| Makefile | ---> | Compiler |  ==> ...
	+----------+      +----------+
	     |                ^
	     v                |
	 ---------            
{:diagram title="My diagram"}


{:diagram: style=""}

How to do vertical bold arrows?

	!
	V 

Curved arrows:
                             +-> | Yes: |
	 ___________________    /
	| is the agent ok? | --|
	 --------------{:r}+

	{:r: border="solid 3px red"}

Big boxes:

	+-------+
	|{:long}|  ---> 
	+-------+
	
	{+long: This is a long box}
	
Or

	+----------------+         ________
	| This is a very |  --->  | Box    |
	| long cell      |        |________|
	+----------------+
	          - Yes
	        /  
	-------+ 
	        \
	          - No







*** Output of inspect ***
md_el(:document,[
	md_par([
		"I would like to add a syntax for drawing basic diagrams and convert them to PNG/PDF/SVG."
	]),
	md_el(:code,[],{:raw_code=>"+----------+      +----------+\n| Makefile | ---> | Compiler |  ==> ...\n+----------+      +----------+\n     |                ^\n     v                |\n ---------            "},[[:ref, "diagram"], ["title", "My diagram"]]),
	md_el(:ald,[],{:ald=>[],:ald_id=>"diagram"},[]),
	md_par(["How to do vertical bold arrows?"]),
	md_el(:code,[],{:raw_code=>"!\nV \n"},[]),
	md_par([
		"Curved arrows: +-> | Yes: | ___________________ / | is the agent ok? | ",
		md_entity("ndash"),
		"| ",
		md_entity("mdash"),
		md_entity("mdash"),
		md_entity("mdash"),
		md_entity("mdash"),
		md_entity("ndash"),
		"+"
	]),
	md_el(:code,[],{:raw_code=>"{:r: border=\"solid 3px red\"}\n"},[]),
	md_par(["Big boxes:"]),
	md_el(:code,[],{:raw_code=>"+-------+\n|{:long}|  ---> \n+-------+\n\n{+long: This is a long box}"},[]),
	md_par(["Or"]),
	md_el(:code,[],{:raw_code=>"+----------------+         ________\n| This is a very |  --->  | Box    |\n| long cell      |        |________|\n+----------------+\n          - Yes\n        /  \n-------+ \n        \\\n          - No"},[])
],{},[])
*** Output of to_html ***

<p>I would like to add a syntax for drawing basic diagrams and convert them to PNG/PDF/SVG.</p>

<pre><code>+----------+      +----------+
| Makefile | ---&gt; | Compiler |  ==&gt; ...
+----------+      +----------+
     |                ^
     v                |
 ---------            </code></pre>

<p>How to do vertical bold arrows?</p>

<pre><code>!
V 
</code></pre>

<p>Curved arrows: +-&gt; | Yes: | ___________________ / | is the agent ok? | &#8211;| &#8212;&#8212;&#8212;&#8212;&#8211;+</p>

<pre><code>{:r: border=&quot;solid 3px red&quot;}
</code></pre>

<p>Big boxes:</p>

<pre><code>+-------+
|{:long}|  ---&gt; 
+-------+

{+long: This is a long box}</code></pre>

<p>Or</p>

<pre><code>+----------------+         ________
| This is a very |  ---&gt;  | Box    |
| long cell      |        |________|
+----------------+
          - Yes
        /  
-------+ 
        \
          - No</code></pre>

*** Output of to_latex ***
I would like to add a syntax for drawing basic diagrams and convert them to PNG/PDF/SVG.

\begin{verbatim}+----------+      +----------+
| Makefile | ---> | Compiler |  ==> ...
+----------+      +----------+
     |                ^
     v                |
 ---------            \end{verbatim}
How to do vertical bold arrows?

\begin{verbatim}!
V 
\end{verbatim}
Curved arrows: +-{\tt \char62} | Yes: | \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ / | is the agent ok? | --{}| ---{}---{}---{}---{}--{}+

\begin{verbatim}{:r: border="solid 3px red"}
\end{verbatim}
Big boxes:

\begin{verbatim}+-------+
|{:long}|  ---> 
+-------+

{+long: This is a long box}\end{verbatim}
Or

\begin{verbatim}+----------------+         ________
| This is a very |  --->  | Box    |
| long cell      |        |________|
+----------------+
          - Yes
        /  
-------+ 
        \
          - No\end{verbatim}

*** Output of to_md ***
I would like to add a syntax for
drawing basic diagrams and convert them
to PNG/PDF/SVG.

How to do vertical bold arrows?

Curved arrows: +-> | Yes: |
___________________ / | is the agent
ok? | | +

Big boxes:

Or


*** Output of to_s ***
I would like to add a syntax for drawing basic diagrams and convert them to PNG/PDF/SVG.How to do vertical bold arrows?Curved arrows: +-> | Yes: | ___________________ / | is the agent ok? | | +Big boxes:Or
*** EOF ***



	OK!



*** Output of Markdown.pl ***
<p>I would like to add a syntax for drawing basic diagrams
and convert them to PNG/PDF/SVG.</p>

<pre><code>+----------+      +----------+
| Makefile | ---&gt; | Compiler |  ==&gt; ...
+----------+      +----------+
     |                ^
     v                |
 ---------
</code></pre>

<p>{:diagram title="My diagram"}</p>

<p>{:diagram: style=""}</p>

<p>How to do vertical bold arrows?</p>

<pre><code>!
V
</code></pre>

<p>Curved arrows:
                             +-> | Yes: |
     <strong><em>_</em><em>_</em><em>_</em><em>_</em><em>_</em></strong>    /
    | is the agent ok? | --|
     --------------{:r}+</p>

<pre><code>{:r: border="solid 3px red"}
</code></pre>

<p>Big boxes:</p>

<pre><code>+-------+
|{:long}|  ---&gt; 
+-------+

{+long: This is a long box}
</code></pre>

<p>Or</p>

<pre><code>+----------------+         ________
| This is a very |  ---&gt;  | Box    |
| long cell      |        |________|
+----------------+
          - Yes
        /  
-------+ 
        \
          - No
</code></pre>

*** Output of Markdown.pl (parsed) ***
<p>I would like to add a syntax for drawing basic diagrams
and convert them to PNG/PDF/SVG.</p
   ><pre
     ><code>+----------+      +----------+
| Makefile | ---&gt; | Compiler |  ==&gt; ...
+----------+      +----------+
     |                ^
     v                |
 ---------
</code
   ></pre
   ><p>{:diagram title="My diagram"}</p
   ><p>{:diagram: style=""}</p
   ><p>How to do vertical bold arrows?</p
   ><pre
     ><code>!
V
</code
   ></pre
   ><p>Curved arrows:
                             +-> | Yes: |
     <strong
       ><em>_</em
       ><em>_</em
       ><em>_</em
       ><em>_</em
       ><em>_</em
     ></strong
     >    /
    | is the agent ok? | --|
     --------------{:r}+</p
   ><pre
     ><code>{:r: border="solid 3px red"}
</code
   ></pre
   ><p>Big boxes:</p
   ><pre
     ><code>+-------+
|{:long}|  ---&gt; 
+-------+

{+long: This is a long box}
</code
   ></pre
   ><p>Or</p
   ><pre
     ><code>+----------------+         ________
| This is a very |  ---&gt;  | Box    |
| long cell      |        |________|
+----------------+
          - Yes
        /  
-------+ 
        \
          - No
</code
   ></pre
 >