//
//  EditPaneTextView.h
//  MarkdownLive
//
//  Created by Akihiro Noguchi on 9/05/11.
//  Copyright 2011 Aki. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EditPaneLayoutManager;

@interface EditPaneTextView : NSTextView {
	EditPaneLayoutManager *layoutMan;
}

@end
