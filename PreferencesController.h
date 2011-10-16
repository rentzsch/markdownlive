//
//  PreferencesController.h
//  MarkdownLive
//
//  Created by Akihiro Noguchi on 7/05/11.
//  Copyright 2011 Aki. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kEditPaneFontNameChangedNotification;

@interface PreferencesController : NSObject {
	IBOutlet NSWindow *prefWindow;
	IBOutlet NSTextField *fontPreviewField;
}

- (IBAction)resetEditPanePreferences:(id)sender;
- (IBAction)showFonts:(id)sender;

@end
