//
//  TCLayoutManager.h
//  MarkdownLive
//
//  Created by Akihiro Noguchi on 7/05/11.
//  Copyright 2011 Aki. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EditPaneLayoutManager : NSLayoutManager {
	NSFont *font;
}

@property (nonatomic, retain) NSFont *font;

- (CGFloat)lineHeight;

@end
