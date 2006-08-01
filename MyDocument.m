#import "MyDocument.h"
#import "NSTask+runScriptNamed.h"

NSString	*kMarkdownDocumentType = @"MarkdownDocumentType";

@interface NSResponder (scrollToEndOfDocument)
- (IBAction)scrollToEndOfDocument:(id)sender; // For some reason this isn't declared anywhere in AppKit.
@end

@implementation MyDocument

- (NSString*)markdown2html:(NSString*)markdown_ {
	
	NSString *dumbQuoteHTML = [NSTask runScriptNamed:@"Markdown" extension:@"pl" input:markdown_ error:nil];
	NSString *smartQuoteHTML = nil;
	if (dumbQuoteHTML)
		smartQuoteHTML = [NSTask runScriptNamed:@"SmartyPants" extension:@"pl" input:dumbQuoteHTML error:nil];
	
	return smartQuoteHTML;
}

- (id)init {
    self = [super init];
    if (self) {
		markdownSource = [[NSMutableAttributedString alloc] initWithString:@""
																attributes:[NSDictionary dictionaryWithObject:[NSFont fontWithName:@"Monaco" size:9.0]
																									   forKey:NSFontAttributeName]];
		
		markdownFileEncoding = NSUTF8StringEncoding;
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
    [super windowControllerDidLoadNib:controller_];
}

- (BOOL)writeToURL:(NSURL*)absoluteURL_ ofType:(NSString*)typeName_ error:(NSError**)error_ {
	BOOL result = NO;
	if ([typeName_ isEqualToString:kMarkdownDocumentType]) {
		result = [[markdownSource string] writeToURL:absoluteURL_
										  atomically:YES
											encoding:markdownFileEncoding
											   error:error_];
		
	}
	
	return result;
}

- (BOOL)readFromURL:(NSURL*)absoluteURL_ ofType:(NSString*)typeName_ error:(NSError**)error_ {
	BOOL result = NO;
	if ([typeName_ isEqualToString:kMarkdownDocumentType]) {
		NSError *error = nil;
		NSString *markdownSourceString = [NSString stringWithContentsOfURL:absoluteURL_
														   usedEncoding:&markdownFileEncoding
																  error:&error];
		if ([error code] == NSFileReadInapplicableStringEncodingError
			&& [[error domain] isEqualToString:NSCocoaErrorDomain])
		{
			//	Hit the "The file could not be opened using specified text encoding." error. -[NSString
			//	stringWithContentsOfFile:usedEncoding:error:] only sniffs the uncommon UTF-16, not UTF-8
			//	or even ASCII. Suck. Try again using UTF-8 explicitly.
			error = nil;
			markdownFileEncoding = NSUTF8StringEncoding;
			markdownSourceString = [NSString stringWithContentsOfURL:absoluteURL_
															encoding:markdownFileEncoding
															   error:&error];
		}
		
		if (!error) {
			NSAssert(markdownSourceString, nil);
			[markdownSource release];
			markdownSource = [[NSMutableAttributedString alloc] initWithString:markdownSourceString
																	attributes:[NSDictionary dictionaryWithObject:[NSFont fontWithName:@"Monaco" size:9.0]
																										   forKey:NSFontAttributeName]];
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
		[[htmlPreviewWebView mainFrame] loadHTMLString:[self markdown2html:[markdownSource string]]
											   baseURL:[self fileName] ? [NSURL fileURLWithPath:[self fileName]] : nil];
	}
}

- (void)webView:(WebView*)sender_ didFinishLoadForFrame:(WebFrame*)frame_ {
	if ([htmlPreviewWebView mainFrame] == frame_ && hasSavedOrigin) {
		hasSavedOrigin = NO;
		if (savedAtBottom)
			[[frame_ frameView] scrollToEndOfDocument:nil];
		else
			[[[frame_ frameView] documentView] scrollPoint:savedOrigin];
	}
}

- (IBAction)copyGeneratedHTMLAction:(id)sender {
	[[NSPasteboard generalPasteboard] declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
	[[NSPasteboard generalPasteboard] setString:[self markdown2html:[markdownSource string]] forType:NSStringPboardType];
}

@end
