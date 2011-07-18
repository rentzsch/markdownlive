/*******************************************************************************
	MyDocument.h - <http://github.com/rentzsch/MarkdownLive>
		Copyright (c) 2006-2010 Jonathan 'Wolf' Rentzsch: <http://rentzsch.com>
		Some rights reserved: <http://opensource.org/licenses/mit-license.php>

	***************************************************************************/

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@class EditPaneTextView;
@class EditPaneLayoutManager;

@interface MyDocument : NSDocument {
	IBOutlet	EditPaneTextView			*markdownSourceTextView;
	IBOutlet	WebView						*htmlPreviewWebView;
	
				NSTextStorage				*markdownSource;
	
				NSTimeInterval				whenToUpdatePreview;
				NSTimer						*htmlPreviewTimer;
				
				BOOL						hasSavedOrigin;
				NSPoint						savedOrigin;
				BOOL						savedAtBottom;
}

- (IBAction)copyGeneratedHTMLAction:(id)sender;

@end
