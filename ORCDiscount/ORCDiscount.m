//
//  ORCDiscount.m
//  MarkdownLive
//
//  Created by Jonathan on 09/07/2011.
//  Copyright 2011 mugginsoft.com. All rights reserved.
//


#import "ORCDiscount.h"
#import "discountWrapper.h"

@implementation ORCDiscount

+ (NSString *)markdown2HTML:(NSString *)markdown_ {
	if (!markdown_) {
		return @"";
	}
	
	return discountToHTML(markdown_);
}

+ (NSString *)HTMLPage:(NSString *)markdownHTML withCSSHTML:(NSString *)cssHTML
{
	return [NSString stringWithFormat:
			@"<!DOCTYPE html>\n<html>\n<head>\n<title>%@</title>\n%@</head>\n<body>%@</body>\n</html>",
			@"Markdown Preview",
			cssHTML,
			markdownHTML
			];
}

+ (NSString *)HTMLPage:(NSString *)markdownHTML withCSSFromURL:(NSURL *)cssURL
{
	NSString *cssHTML = [NSString stringWithFormat:
						 @"<link rel=\"stylesheet\" type=\"text/css\" href=\"%@\">\n",
						 [cssURL absoluteString]
						 ];
	return [self HTMLPage:markdownHTML withCSSHTML:cssHTML];
}
@end
