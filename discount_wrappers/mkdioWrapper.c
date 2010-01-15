/*******************************************************************************
	mkdioWrapper.c - <http://github.com/rentzsch/MarkdownLive>
		Copyright (c) 2006-2010 Jonathan 'Wolf' Rentzsch: <http://rentzsch.com>
		Some rights reserved: <http://opensource.org/licenses/mit-license.php>

	***************************************************************************/

//#include "mkdioWrapper.h"
#include "mkdio.h"

#define Document void

Document* mkd_string_wrapper(char *buf, int len, int flags) {
    return mkd_string(buf, len, flags);
}

void mkd_cleanup_wrapper(Document *doc) {
    mkd_cleanup(doc);
}
