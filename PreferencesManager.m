//
//  PreferencesManager.m
//  MarkdownLive
//
//  Created by Akihiro Noguchi on 7/05/11.
//  Copyright 2011 Aki. All rights reserved.
//

#import "PreferencesManager.h"

#define kEditPaneFontName @"EditPaneFontName"
#define kEditPaneFontSize @"EditPaneFontSize"


@implementation PreferencesManager

+ (void)initialize {
	NSDictionary *defVals = [NSDictionary dictionaryWithObjectsAndKeys:
							 @"Monaco", kEditPaneFontName,
							 [NSNumber numberWithFloat:9.0f], kEditPaneFontSize,
							 nil];
	[[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:defVals];
}

+ (NSString *)editPanelFontName {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	return [prefs stringForKey:kEditPaneFontName];
}

+ (void)setEditPanelFontName:(NSString *)value {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:value forKey:kEditPaneFontName];
}

+ (float)editPanelFontSize {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	return [prefs floatForKey:kEditPaneFontSize];
}

+ (void)setEditPanelFontSize:(float)value {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setFloat:value forKey:kEditPaneFontSize];
}

+ (NSFont *)editPanelFont {
	return [NSFont fontWithName:[PreferencesManager editPanelFontName]
						   size:[PreferencesManager editPanelFontSize]];
}

@end
