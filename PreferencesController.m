//
//  PreferencesController.m
//  MarkdownLive
//
//  Created by Akihiro Noguchi on 7/05/11.
//  Copyright 2011 Aki. All rights reserved.
//

#import "PreferencesController.h"
#import "PreferencesManager.h"

#define FONT_DISPLAY_FORMAT @"%@ %g pt."


@implementation PreferencesController

- (void)awakeFromNib {
	NSString *fontName = [PreferencesManager editPanelFontName];
	float fontSize = [PreferencesManager editPanelFontSize];
	[fontPreviewField setStringValue:[NSString stringWithFormat:FONT_DISPLAY_FORMAT, fontName, fontSize]];
}

- (IBAction)showFonts:(id)sender {
	NSFontManager *fontMan = [NSFontManager sharedFontManager];
	NSFont *currentFont = [PreferencesManager editPanelFont];
	[prefWindow makeFirstResponder:prefWindow];
	[fontMan setSelectedFont:currentFont isMultiple:NO];
	[fontMan orderFrontFontPanel:sender];
}

- (void)changeFont:(id)sender {
	NSFont *newFont = [sender convertFont:[NSFont systemFontOfSize:0]];
	NSString *fontName = [newFont fontName];
	float fontSize = [newFont pointSize];
	
	if (newFont && fontName) {
		[PreferencesManager setEditPanelFontName:fontName];
		[PreferencesManager setEditPanelFontSize:fontSize];
		[fontPreviewField setStringValue:[NSString stringWithFormat:FONT_DISPLAY_FORMAT, fontName, fontSize]];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:kEditPaneFontNameChangedNotification
															object:nil];
	}
}

@end
