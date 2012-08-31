/*******************************************************************************
	MyDocument.m - <http://github.com/rentzsch/MarkdownLive>
		Copyright (c) 2006-2011 Jonathan 'Wolf' Rentzsch: <http://rentzsch.com>
		Some rights reserved: <http://opensource.org/licenses/mit-license.php>

	***************************************************************************/

#import "ORCDiscount.h"
#import "MyDocument.h"
#import "EditPaneLayoutManager.h"
#import "EditPaneTextView.h"
#import "PreferencesController.h"
#import "PreferencesManager.h"
#include "discountWrapper.h"

NSString	*kMarkdownDocumentType = @"MarkdownDocumentType";

// class extension
@interface MyDocument ()

- (void)updateContent;
- (void)htmlPreviewTimer:(NSTimer*)timer_;

@end

@implementation MyDocument

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
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(textDidChange:)
													 name:kEditPaneTextViewChangedNotification
												   object:markdownSourceTextView];
		
		// print attributes
		[[self printInfo] setHorizontalPagination:NSFitPagination];
		[[self printInfo] setHorizontallyCentered:NO];
		[[self printInfo] setVerticallyCentered:NO];
	}
	return self;
}

- (void)dealloc {
	[htmlPreviewTimer invalidate]; htmlPreviewTimer = nil;
	[markdownSource release]; markdownSource = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

- (NSString *)windowNibName {
	return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)controller_ {
	static BOOL engagedAutosave = NO;
	if (!engagedAutosave) {
		engagedAutosave = YES;
		[[NSDocumentController sharedDocumentController] setAutosavingDelay:5.0];
	}
	
	[[markdownSourceTextView layoutManager] replaceTextStorage:markdownSource];
	[self updateContent];
	
	// If you use IB to set an NSTextView's font, the font doesn't stick,
	// even if you've turned off the text view's richText setting.
	[markdownSourceTextView updateFont];
	[markdownSourceTextView updateColors];
	
	[super windowControllerDidLoadNib:controller_];
}

- (BOOL)writeToURL:(NSURL*)absoluteURL_
    ofType:(NSString*)typeName_
    forSaveOperation:(NSSaveOperationType)saveOperation_
    originalContentsURL:(NSURL*)absoluteOriginalContentsURL_
    error:(NSError **)error_
{
    BOOL result = NO;
	if ([typeName_ isEqualToString:kMarkdownDocumentType]) {
		[markdownSourceTextView breakUndoCoalescing];
		result = [[markdownSource string] writeToURL:absoluteURL_
										  atomically:YES
											encoding:NSUTF8StringEncoding
											   error:error_];
		
	}
    
    if (result && saveOperation_ != NSAutosaveOperation) {
        NSURL *markdownFileURL = [self fileURL];
        NSURL *htmlFileURL = [[markdownFileURL URLByDeletingPathExtension] URLByAppendingPathExtension:@"html"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[htmlFileURL path]]) {
            NSXMLDocument *doc = [[[NSXMLDocument alloc] initWithContentsOfURL:htmlFileURL
                                                                       options:NSXMLNodePreserveAll|NSXMLDocumentTidyXML
                                                                         error:nil] autorelease];
            if (doc) {
                NSArray *nodes = [doc nodesForXPath:@"//*[@id=\"markdownlive\"]" error:nil];
                if ([nodes count] == 1) {
                    NSXMLElement *node = [nodes objectAtIndex:0];
                    NSXMLDocument *markdownDoc = [[[NSXMLDocument alloc] initWithXMLString:[ORCDiscount markdown2HTML:[markdownSource string]]
                                                                                   options:NSXMLDocumentTidyHTML
                                                                                     error:nil] autorelease];
                    NSArray *markdownNodes = [markdownDoc nodesForXPath:@"/html/body/*" error:nil];
                    [markdownNodes makeObjectsPerformSelector:@selector(detach)];
                    [node setChildren:markdownNodes];
                    NSString *htmlFileContent = [doc XMLStringWithOptions:NSXMLNodePrettyPrint];
                    if ([htmlFileContent hasPrefix:@"<?xml"]) {
                        NSUInteger index = [htmlFileContent rangeOfString:@"\n"].location;
                        htmlFileContent = [htmlFileContent substringFromIndex:index+1];
                    }
                    [htmlFileContent writeToURL:htmlFileURL
                                     atomically:YES
                                       encoding:NSUTF8StringEncoding
                                          error:nil];
                }
            }
        }
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

- (NSView *)printableView {
	NSRect frame = [[self printInfo] imageablePageBounds];
	frame.size.height = 0;
	NSTextView *printView = [[[NSTextView alloc] initWithFrame:frame] autorelease];
    [printView setVerticallyResizable:YES];
    [printView setHorizontallyResizable:NO];
	
	// force black text color
	NSMutableAttributedString *printStr = [markdownSource mutableCopy];
	NSDictionary *printAttr = [NSDictionary dictionaryWithObject:[NSColor blackColor]
														  forKey:NSForegroundColorAttributeName];
	[printStr setAttributes:printAttr
					  range:NSMakeRange(0, [printStr length])];
	
    [[printView textStorage] beginEditing];
    [[printView textStorage] appendAttributedString:printStr];
	[printStr release];
    [[printView textStorage] endEditing];
    
    [printView sizeToFit];
    
    return printView;
}

- (NSPrintOperation *)printOperationWithSettings:(NSDictionary *)printSettings error:(NSError **)outError {
	
#pragma unused(printSettings)
#pragma unused(outError)
	
	return [NSPrintOperation printOperationWithView:[self printableView]
										  printInfo:[self printInfo]];
}

- (void)textDidChange:(NSNotification*)notification_ {
	
#pragma unused(notification_)
	
	whenToUpdatePreview = [NSDate timeIntervalSinceReferenceDate] + 0.5;
}

- (void)updateContent {
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
	
	NSURL *css = [ORCDiscount cssURL];
	NSString *html = [ORCDiscount HTMLPage:[ORCDiscount markdown2HTML:[markdownSource string]] withCSSFromURL:css];
	[[htmlPreviewWebView mainFrame] loadHTMLString:html baseURL:[self fileURL]];
}

- (void)htmlPreviewTimer:(NSTimer*)timer_ {
	
#pragma unused(timer_)
	
	if ([NSDate timeIntervalSinceReferenceDate] >= whenToUpdatePreview) {
		whenToUpdatePreview = [[NSDate distantFuture] timeIntervalSinceReferenceDate];
		[self updateContent];
	}
}

- (void)webView:(WebView*)sender_ didFinishLoadForFrame:(WebFrame*)frame_ {
	
#pragma unused(sender_)
	
	if ([htmlPreviewWebView mainFrame] == frame_ && hasSavedOrigin) {
		hasSavedOrigin = NO;
		if (savedAtBottom)
			[[[frame_ frameView] documentView] scrollPoint:NSMakePoint(savedOrigin.x, CGFLOAT_MAX)];
		else
			[[[frame_ frameView] documentView] scrollPoint:savedOrigin];
	}
}

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation
		request:(NSURLRequest *)request
		  frame:(WebFrame *)frame decisionListener:(id < WebPolicyDecisionListener >)listener {

#pragma unused(webView)
#pragma unused(request)
#pragma unused(frame)
	
	WebNavigationType actionKey = [[actionInformation objectForKey:WebActionNavigationTypeKey] intValue];
	if (actionKey == WebNavigationTypeOther) {
		[listener use];
	} else {
		NSURL *url = [actionInformation objectForKey:WebActionOriginalURLKey];
		
		NSURL *stdUrl = [url URLByStandardizingPath];
		NSURL *docUrl = [[self fileURL] URLByStandardizingPath];
		if ([[url scheme] isEqualToString:@"applewebdata"] ||
			([stdUrl isFileURL] && [stdUrl isEqualTo:docUrl])) {
			[listener use];
		} else {
			[[NSWorkspace sharedWorkspace] openURL:url];
			[listener ignore];
		}
	}
}

- (IBAction)copyGeneratedHTMLAction:(id)sender {
	
	#pragma unused(sender)
	
	[[NSPasteboard generalPasteboard] declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
	[[NSPasteboard generalPasteboard] setString:[ORCDiscount markdown2HTML:[markdownSource string]] forType:NSStringPboardType];
}

@end
