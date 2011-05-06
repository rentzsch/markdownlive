//
//  PreferencesManager.h
//  MarkdownLive
//
//  Created by Akihiro Noguchi on 7/05/11.
//  Copyright 2011 Aki. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PreferencesManager : NSObject {

}

+ (NSString *)editPanelFontName;
+ (void)setEditPanelFontName:(NSString *)value;
+ (float)editPanelFontSize;
+ (void)setEditPanelFontSize:(float)value;
+ (NSFont *)editPanelFont;

@end
