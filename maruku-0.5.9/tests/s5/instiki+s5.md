author: Jacques Distler
company: University of Texas at Austin
title: S5 Integration
subtitle: slides in Instiki
slide_footer: Released to the Internets
slide_subfooter: March 1, 2007

:category: S5-slideshow

S5 Integration
==============

S5
--------------------------------------

1. [S5](http://meyerweb.com/eric/tools/s5/) is an open-source presentation package, written by Eric Meyer.
2. Andrea Censi included some basic S5 support in [Maruku](http://maruku.rubyforge.org/), his Ruby Markdown implementation.
2. My role was to
   * make it compatible[^xhtml] with real XHTML
   * integrate it into Instiki
3. Driven by Maruku and itex2MML, it's trivial to include equations, inline SVG graphics, etc.
   
[^xhtml]: This consisted of fixing the Javascript to use DOM-scripting, instead of `innerHTML`.

Composing a presentation
--------------------------------------

At the top of this presentation, is some header information:

     author: Jacques Distler
     company: University of Texas at Austin
     title: S5 Integration
     subtitle: slides in Instiki
     slide_footer: Released to the Internets
     slide_subfooter: March 1, 2007

     :category: S5-slideshow

The `:category: S5-slideshow` is essential. It tells Instiki that this page is an S5 slideshow. Any page in this category has an extra "S5" view, in addition to the "TeX" and "Print" views. The rest of the header fields are optional. If you omit `author: ...`, then the name of the person who last edited the page is used. If you omit `title: ...`, then the name of the page is used.

Composing ...
-----------------------------------------

After that header information, is a series of slides

     My Slideshow
     ==============

     First Slide Title
     -----------------

     * First point
     * Second point

     Second Slide Title
     ------------------

     * Another boring bullet point.

etc.


Features
--------------------------------------

* Mathematics, either inline $\left(\frac{\sin(\pi x)}{\pi x}\right)$ or block
\[
\label{gaussian}
  \int_{\infty}^{\infty}e^{-x^2} \mathrm{d}x = \sqrt{\pi}
\]
are fully supported. You just type standard [itex](http://golem.ph.utexas.edu/~distler/blog/itex2MMLcommands.html), and equations like (eq:gaussian) just appear.
* Incremental display is supported.
* Notes are allowed, but there isn't (yet) a native Maruku syntax for entering them. _Horror of horrors!_ You need to type a little XHTML markup to get them.
{: .incremental .show-first}

<div markdown="1" class="notes">

You have to type

     &lt;div class="notes"&gt;

     These are my notes for this slide.

     &lt;/div&gt;

Usually, these optional notes contain the gory details and complicated equations, like $E=m c^2$, too messy to be presented in the main thread of the talk.

</div>


Features II
---------------------------------------------------

To get incremental display, use Maruku's [metadata syntax](http://maruku.rubyforge.org/proposal.html)
{: .incremental}

* Place a `{: .incremental .show-first}` or `{: .incremental}` to get incremental display.

   * This even works with nested lists.
   {: .incremental}

* Yes, all of S5's [other features](http://meyerweb.com/eric/tools/s5/features.html) are there, too.
* Of course, it doesn't have all the garish visual effects of Apple's Keynote.
* If you can't do without garish, tacky, visual effects, there's always SVG.
{: .incremental}
