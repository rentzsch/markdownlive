# MarkdownLive 1.4 Sun May 21 2008

* Switch to discount for markdown engine. Saves having to spawn a Perl/ruby instance all the time. maruku also had rendering quirks, including not rendering things like `C4[2]` correctly, forcing me to write `C4\[2\]`.

	But discount has a really strange source layout, to the point where I need to separate write wrappers for a couple of functions because you can't #include multiple header files since their typedefs conflict (`Document`). discount also defines `Line`, in conflict with QuickDraw, so I do preprocessor hackery to work-around that as well (<http://lists.apple.com/archives/Xcode-users/2008/Sep/msg00537.html>).

* MarkdownLive now autosaves.

---

# MarkdownLive 1.3 Jul 31 2008

* Now uses [maruku](http://maruku.rubyforge.org) for its engine to get things like "Markdown inside HTML elements" and definition lists.

---

# MarkdownLive-0 May 21 2006

* Supplies a category on `NSTask` (`+runScriptNamed:extension:input:error:`) that handles running external scripts. Marshals `NSString` parameters into `STDIN`/`STDOUT` pipe read/writes.

* Utilizes both Markdown and SmartyPants in sequence.

* Throttles calling the external scripts (which is rather heavyweight) to twice a second, no matter now fast you type.

* Implements a slight delay (currently half a second) when updating the HTML preview. Turns out not only is this nice, it's necessary if you want stable scrolling on the WebKit preview view. If you have "smooth scrolling" on, something notices space bar keydowns and forces a scroll view update before your `+webView:didFinishLoadForFrame:` delegate callback is called to fix-up the WebView's scroll setting. This results in animated "jumping" whenever you press the spacebar. Ick.

* Has rather nice scrolling behavior. Remembers your scroll position as you type (a necessary feature, see http://rentzsch.com/bugs/previewInBBEdit) unless you've scrolled to the bottom, then the scroll stays locked to the bottom as you type.

* Source text and preview view exist in one integrated window.

* Uses the undocumented `-scrollToEndOfDocument:` NSResponder call. I don't know why it's undocumented.

* Illustrates the stupidity `-[NSString stringWithContentsOfURL:usedEncoding:error]` method. It only sniffs uncommon UTF-16, making it worse than worthless.