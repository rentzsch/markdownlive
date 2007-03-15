#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface MyDocument : NSDocument {
	IBOutlet	NSTextView					*markdownSourceTextView;
	IBOutlet	WebView						*htmlPreviewWebView;
	
				NSMutableAttributedString	*markdownSource;
	
				NSTimeInterval				whenToUpdatePreview;
				NSTimer						*htmlPreviewTimer;
				
				BOOL						hasSavedOrigin;
				NSPoint						savedOrigin;
				BOOL						savedAtBottom;
}

- (IBAction)copyGeneratedHTMLAction:(id)sender;

@end
