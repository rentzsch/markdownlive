/*******************************************************************************
	markdownWrapper.c - <http://github.com/rentzsch/MarkdownLive>
		Copyright (c) 2006-2011 Jonathan 'Wolf' Rentzsch: <http://rentzsch.com>
		Some rights reserved: <http://opensource.org/licenses/mit-license.php>

	***************************************************************************/

//#include "markdownWrapper.h"

#include <stdio.h>
#include "markdown.h"

int mkd_compile_wrapper(Document *doc, int flags) {
    return mkd_compile(doc, flags);
}

int mkd_document_wrapper(Document *p, char **res) {
    return mkd_document(p, res);
}

