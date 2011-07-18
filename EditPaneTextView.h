//
//  EditPaneTextView.h
//  MarkdownLive
//
//  Created by Akihiro Noguchi on 9/05/11.
//  Copyright 2011 Aki. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kEditPaneTextViewChangedNotification @"EditPaneTextViewChangedNotification"

@class EditPaneLayoutManager;

@interface EditPaneTextView : NSTextView {
	EditPaneLayoutManager *layoutMan;
}

- (void)updateColors;
- (void)updateFont;

@end
