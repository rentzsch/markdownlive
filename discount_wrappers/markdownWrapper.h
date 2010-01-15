/*******************************************************************************
	markdownWrapper.h - <http://github.com/rentzsch/MarkdownLive>
		Copyright (c) 2006-2010 Jonathan 'Wolf' Rentzsch: <http://rentzsch.com>
		Some rights reserved: <http://opensource.org/licenses/mit-license.php>

	***************************************************************************/

#ifndef		_mkdioWrapper_
#define		_mkdioWrapper_

int mkd_compile_wrapper(Document *doc, int flags);
int mkd_document_wrapper(Document *p, char **res);

#endif	//	_mkdioWrapper_