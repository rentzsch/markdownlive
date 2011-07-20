/*******************************************************************************
	mkdioWrapper.h - <http://github.com/rentzsch/MarkdownLive>
		Copyright (c) 2006-2011 Jonathan 'Wolf' Rentzsch: <http://rentzsch.com>
		Some rights reserved: <http://opensource.org/licenses/mit-license.php>

	***************************************************************************/

#ifndef		_mkdioWrapper_
#define		_mkdioWrapper_

Document* mkd_string_wrapper(char *buf, int len, int flags);
void mkd_cleanup_wrapper(Document *doc);

#endif	//	_mkdioWrapper_