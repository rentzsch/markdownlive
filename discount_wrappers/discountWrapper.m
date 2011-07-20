/*******************************************************************************
	discountWrapper.m - <http://github.com/rentzsch/MarkdownLive>
		Copyright (c) 2006-2011 Jonathan 'Wolf' Rentzsch: <http://rentzsch.com>
		Some rights reserved: <http://opensource.org/licenses/mit-license.php>

	***************************************************************************/

#include "discountWrapper.h"

#define Line discountLine
#include "markdown.h"
#undef Line

#include "mkdioWrapper.h"
#include "markdownWrapper.h"

NSString* discountToHTML(NSString *markdown) {
    NSString *result = nil;
    
    char *markdownUTF8 = (char*)[markdown UTF8String];
    Document *document = mkd_string_wrapper(markdownUTF8, strlen(markdownUTF8), 0);
    if (document) {
        if (mkd_compile_wrapper(document, 0)) {
            char *htmlUTF8;
            int htmlUTF8Len = mkd_document_wrapper(document, &htmlUTF8);
            if (htmlUTF8Len != EOF) {
                result = [[[NSString alloc] initWithBytes:htmlUTF8
                                                   length:htmlUTF8Len
                                                 encoding:NSUTF8StringEncoding] autorelease];
            }
            mkd_cleanup_wrapper(document);
        }
    }
    
    return result;
}