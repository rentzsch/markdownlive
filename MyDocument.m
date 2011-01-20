/*******************************************************************************
	MyDocument.m - <http://github.com/rentzsch/MarkdownLive>
		Copyright (c) 2006-2010 Jonathan 'Wolf' Rentzsch: <http://rentzsch.com>
		Some rights reserved: <http://opensource.org/licenses/mit-license.php>

	***************************************************************************/

#import "MyDocument.h"
#include "discountWrapper.h"

NSString	*kMarkdownDocumentType = @"MarkdownDocumentType";

@implementation MyDocument

- (NSString*)markdown2html:(NSString*)markdown_ {
	if (!markdown_)
		return @"";
    
    return discountToHTML(markdown_);
}

- (id)init {
    self = [super init];
    if (self) {
		markdownSource = [[NSTextStorage alloc] init];
		whenToUpdatePreview = [[NSDate distantFuture] timeIntervalSinceReferenceDate];
		htmlPreviewTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
															target:self
														  selector:@selector(htmlPreviewTimer:)
														  userInfo:nil
														   repeats:YES];
    }
    return self;
}

- (void)dealloc {
	[htmlPreviewTimer invalidate]; htmlPreviewTimer = nil;
	[markdownSource release]; markdownSource = nil;
	[super dealloc];
}

- (NSString *)windowNibName {
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController*)controller_ {
    static BOOL engagedAutosave = NO;
    if (!engagedAutosave) {
        engagedAutosave = YES;
        [[NSDocumentController sharedDocumentController] setAutosavingDelay:5.0];
    }
	
	[[markdownSourceTextView layoutManager] replaceTextStorage:markdownSource];
	
	// If you use IB to set an NSTextView's font, the font doesn't stick,
	// even if you've turned off the text view's richText setting.
	[markdownSourceTextView setFont:[NSFont fontWithName:@"Monaco" size:9]];
	
    [super windowControllerDidLoadNib:controller_];
}

- (BOOL)writeToURL:(NSURL*)absoluteURL_ ofType:(NSString*)typeName_ error:(NSError**)error_ {
	BOOL result = NO;
	if ([typeName_ isEqualToString:kMarkdownDocumentType]) {
		[markdownSourceTextView breakUndoCoalescing];
		result = [[markdownSource string] writeToURL:absoluteURL_
										  atomically:YES
											encoding:NSUTF8StringEncoding
											   error:error_];
		
	}
	
	return result;
}

- (BOOL)readFromURL:(NSURL*)absoluteURL_ ofType:(NSString*)typeName_ error:(NSError**)error_ {
	BOOL result = NO;
	if ([typeName_ isEqualToString:kMarkdownDocumentType]) {
		NSError *error = nil;
		NSString *markdownSourceString = [NSString stringWithContentsOfURL:absoluteURL_
															encoding:NSUTF8StringEncoding
															   error:&error];
		if (!error) {
			NSAssert(markdownSourceString, nil);
			[markdownSource release];
			markdownSource = [[NSTextStorage alloc] initWithString:markdownSourceString];
			NSAssert(markdownSource, nil);
			whenToUpdatePreview = [NSDate timeIntervalSinceReferenceDate] + 0.5;
			result = YES;
		}
		if (error_)
			*error_ = error;
	}
	return result;
}

- (void)textDidChange:(NSNotification*)notification_ {
	whenToUpdatePreview = [NSDate timeIntervalSinceReferenceDate] + 0.5;
}

- (NSString *)HTMLPage:(NSString *)markdownHTML withCSSHTML:(NSString *)cssHTML
{
	return [NSString stringWithFormat:
		@"<!DOCTYPE html>\n<html>\n<head>\n<title>%@</title>\n%@</head>\n<body>%@</body>\n</html>",
		@"Markdown Preview",
		cssHTML,
		markdownHTML
	];
}

- (NSString *)HTMLPage:(NSString *)markdownHTML withCSSFromURL:(NSURL *)cssURL
{
	NSString *cssHTML = [NSString stringWithFormat:
		@"<link rel=\"stylesheet\" type=\"text/css\" href=\"%@\">\n",
		[cssURL absoluteString]
	];
	return [self HTMLPage:markdownHTML withCSSHTML:cssHTML];
}

- (void)htmlPreviewTimer:(NSTimer*)timer_ {
	if ([NSDate timeIntervalSinceReferenceDate] >= whenToUpdatePreview) {
		whenToUpdatePreview = [[NSDate distantFuture] timeIntervalSinceReferenceDate];
		
		NSView *docView = [[[htmlPreviewWebView mainFrame] frameView] documentView];
		NSView *parent = [docView superview];
		if (parent) {
			NSAssert([parent isKindOfClass:[NSClipView class]], nil);
			savedOrigin = [parent bounds].origin;
			// This line from Darin from http://lists.apple.com/archives/webkitsdk-dev/2003/Dec/msg00004.html :
			savedAtBottom = [docView isFlipped]
				? NSMaxY([docView bounds]) <= NSMaxY([docView visibleRect])
				: [docView bounds].origin.y >= [docView visibleRect].origin.y;
			hasSavedOrigin = YES;
		}
		NSURL *css = [[NSBundle mainBundle] URLForResource:@"styles" withExtension:@"css"];
		NSString *html = [self HTMLPage:[self markdown2html:[markdownSource string]] withCSSFromURL:css];
		[[htmlPreviewWebView mainFrame] loadHTMLString:html baseURL:[self fileURL]];
	}
}

- (void)webView:(WebView*)sender_ didFinishLoadForFrame:(WebFrame*)frame_ {
	if ([htmlPreviewWebView mainFrame] == frame_ && hasSavedOrigin) {
		hasSavedOrigin = NO;
		if (savedAtBottom)
			[[[frame_ frameView] documentView] scrollPoint:NSMakePoint(savedOrigin.x, CGFLOAT_MAX)];
		else
			[[[frame_ frameView] documentView] scrollPoint:savedOrigin];
	}
}

- (IBAction)copyGeneratedHTMLAction:(id)sender {
	[[NSPasteboard generalPasteboard] declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
	[[NSPasteboard generalPasteboard] setString:[self markdown2html:[markdownSource string]] forType:NSStringPboardType];
}

@end
