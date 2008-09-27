#ifndef		_mkdioWrapper_
#define		_mkdioWrapper_

Document* mkd_string_wrapper(char *buf, int len, int flags);
void mkd_cleanup_wrapper(Document *doc);

#endif	//	_mkdioWrapper_