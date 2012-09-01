//
//  MLAppDelegate.m
//  MarkdownLive
//
//  Created by David Beck on 9/23/11.
//  Copyright 2011 David Beck. Some rights reserved: <http://opensource.org/licenses/mit-license.php>
//

#import "MLAppDelegate.h"

@implementation MLAppDelegate

@synthesize viewMenu = _viewMenu;

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
	if ([NSWindow instancesRespondToSelector:@selector(toggleFullScreen:)]) {
		[[NSApp mainMenu] insertItem:self.viewMenu atIndex:3];
	}
}

@end
