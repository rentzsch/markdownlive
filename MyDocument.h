/*******************************************************************************
	MyDocument.h - <http://github.com/rentzsch/MarkdownLive>
		Copyright (c) 2006-2011 Jonathan 'Wolf' Rentzsch: <http://rentzsch.com>
		Some rights reserved: <http://opensource.org/licenses/mit-license.php>

	***************************************************************************/

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "RKSyntaxView.h"

@class EditPaneTextView;
@class EditPaneLayoutManager;

@interface MyDocument : NSDocument {
	IBOutlet	RKSyntaxView                *markdownSourceTextView;
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
