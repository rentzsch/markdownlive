//
//  PreferencesManager.m
//  MarkdownLive
//
//  Created by Akihiro Noguchi on 7/05/11.
//  Copyright 2011 Aki. All rights reserved.
//

#import "PreferencesManager.h"

@interface PreferencesManager (Private)

+ (NSColor *)colorForKey:(NSString *)key;
+ (void)setColor:(NSColor *)col forKey:(NSString *)key;
+ (NSDictionary *)editPaneDefaults;

@end


@implementation PreferencesManager

+ (void)initialize {
	NSMutableDictionary *defVals = [NSMutableDictionary dictionary];
	[defVals addEntriesFromDictionary:[PreferencesManager editPaneDefaults]];
	[[NSUserDefaults standardUserDefaults] registerDefaults:defVals];
}

+ (NSDictionary *)editPaneDefaults {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			@"Monaco", kEditPaneFontName,
			[NSNumber numberWithFloat:9.0f], kEditPaneFontSize,
			[NSArchiver archivedDataWithRootObject:[NSColor blackColor]], kEditPaneForegroundColor,
			[NSArchiver archivedDataWithRootObject:[NSColor whiteColor]], kEditPaneBackgroundColor,
			[NSArchiver archivedDataWithRootObject:[NSColor selectedTextBackgroundColor]], kEditPaneSelectionColor,
			[NSArchiver archivedDataWithRootObject:[NSColor blackColor]], kEditPaneCaretColor,
			nil];
}

+ (void)resetEditPanePreferences {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSDictionary *defs = [PreferencesManager editPaneDefaults];
	for (NSString *key in defs) {
		[prefs setObject:[defs objectForKey:key] forKey:key];
	}
}

+ (NSString *)editPaneFontName {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	return [prefs stringForKey:kEditPaneFontName];
}

+ (void)setEditPaneFontName:(NSString *)value {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:value forKey:kEditPaneFontName];
}

+ (float)editPaneFontSize {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	return [prefs floatForKey:kEditPaneFontSize];
}

+ (void)setEditPaneFontSize:(float)value {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setFloat:value forKey:kEditPaneFontSize];
}

+ (NSFont *)editPaneFont {
	return [NSFont fontWithName:[PreferencesManager editPaneFontName]
						   size:[PreferencesManager editPaneFontSize]];
}

+ (NSColor *)colorForKey:(NSString *)key {
	if (key) {
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		NSData *data = [prefs dataForKey:key];
		if (data) {
			return (NSColor *)[NSUnarchiver unarchiveObjectWithData:data];
		}
	}
	return nil;
}

+ (void)setColor:(NSColor *)col forKey:(NSString *)key {
	if (col && key) {
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		[prefs setValue:[NSArchiver archivedDataWithRootObject:col] forKey:key];
	}
}

+ (NSColor *)editPaneForegroundColor {
	return [PreferencesManager colorForKey:kEditPaneForegroundColor];
}

+ (void)setEditPaneForegroundColor:(NSColor *)value {
	[PreferencesManager setColor:value forKey:kEditPaneForegroundColor];
}

+ (NSColor *)editPaneBackgroundColor {
	return [PreferencesManager colorForKey:kEditPaneBackgroundColor];
}

+ (void)setEditPaneBackgroundColor:(NSColor *)value {
	[PreferencesManager setColor:value forKey:kEditPaneBackgroundColor];
}

+ (NSColor *)editPaneSelectionColor {
	return [PreferencesManager colorForKey:kEditPaneSelectionColor];
}

+ (void)setEditPaneSelectionColor:(NSColor *)value {
	[PreferencesManager setColor:value forKey:kEditPaneSelectionColor];
}

+ (NSColor *)editPaneCaretColor {
	return [PreferencesManager colorForKey:kEditPaneCaretColor];
}

+ (void)setEditPaneCaretColor:(NSColor *)value {
	[PreferencesManager setColor:value forKey:kEditPaneCaretColor];
}

@end
