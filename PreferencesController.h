//
//  PreferencesController.h
//  MarkdownLive
//
//  Created by Akihiro Noguchi on 7/05/11.
//  Copyright 2011 Aki. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kEditPaneFontNameChangedNotification @"EditPaneFontNameChangedNotification"

@interface PreferencesController : NSObject {
	IBOutlet NSWindow *prefWindow;
	IBOutlet NSTextField *fontPreviewField;
}

- (IBAction)showFonts:(id)sender;

@end
