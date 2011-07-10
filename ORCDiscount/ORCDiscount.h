/*
 *  ORCDiscount.h
 *  MarkdownLive
 *
 *  Created by Jonathan on 09/07/2011.
 *  Copyright 2011 mugginsoft.com. All rights reserved.
 *
 */
#import <Cocoa/Cocoa.h>

@interface ORCDiscount : NSObject {
}

+ (NSString *)markdown2HTML:(NSString *)markdown;
+ (NSString *)HTMLPage:(NSString *)markdownHTML withCSSHTML:(NSString *)cssHTML;
+ (NSString *)HTMLPage:(NSString *)markdownHTML withCSSFromURL:(NSURL *)cssURL;
+ (NSURL *)cssURL;

@end
