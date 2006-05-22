# MarkdownLive-0 Sun May 21 2006

* Supplies a category on `NSTask` (`+runScriptNamed:extension:input:error:`) that handles running external scripts. Marshals `NSString` parameters into `STDIN`/`STDOUT` pipe read/writes.

* Utilizes both Markdown and SmartyPants in sequence.

* Throttles calling the external scripts (which is rather heavyweight) to twice a second, no matter now fast you type.

* Implements a slight delay (currently half a second) when updating the HTML preview. Turns out not only is this nice, it's necessary if you want stable scrolling on the WebKit preview view. If you have "smooth scrolling" on, something notices space bar keydowns and forces a scroll view update before your `+webView:didFinishLoadForFrame:` delegate callback is called to fix-up the WebView's scroll setting. This results in animated "jumping" whenever you press the spacebar. Ick.

* Has rather nice scrolling behavior. Remembers your scroll position as you type (a necessary feature, see http://rentzsch.com/bugs/previewInBBEdit) unless you've scrolled to the bottom, then the scroll stays locked to the bottom as you type.

* Source text and preview view exist in one integrated window.

* Uses the undocumented `-scrollToEndOfDocument:` NSResponder call. I don't know why it's undocumented.

* Illustrates the stupidity `-[NSString stringWithContentsOfURL:usedEncoding:error]` method. It only sniffs uncommon UTF-16, making it worse than worthless.