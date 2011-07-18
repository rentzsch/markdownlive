//
//  PreferencesManager.h
//  MarkdownLive
//
//  Created by Akihiro Noguchi on 7/05/11.
//  Copyright 2011 Aki. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kEditPaneFontName			@"EditPaneFontName"
#define kEditPaneFontSize			@"EditPaneFontSize"
#define kEditPaneForegroundColor	@"EditPaneForegroundColor"
#define kEditPaneBackgroundColor	@"EditPaneBackgroundColor"
#define kEditPaneSelectionColor		@"EditPaneSelectionColor"
#define kEditPaneCaretColor			@"EditPaneCaretColor"


@interface PreferencesManager : NSObject {

}

+ (void)resetEditPanePreferences;
+ (NSString *)editPaneFontName;
+ (void)setEditPaneFontName:(NSString *)value;
+ (float)editPaneFontSize;
+ (void)setEditPaneFontSize:(float)value;
+ (NSFont *)editPaneFont;
+ (NSColor *)editPaneForegroundColor;
+ (void)setEditPaneForegroundColor:(NSColor *)value;
+ (NSColor *)editPaneBackgroundColor;
+ (void)setEditPaneBackgroundColor:(NSColor *)value;
+ (NSColor *)editPaneSelectionColor;
+ (void)setEditPaneSelectionColor:(NSColor *)value;
+ (NSColor *)editPaneCaretColor;
+ (void)setEditPaneCaretColor:(NSColor *)value;

@end
