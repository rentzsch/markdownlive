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

@property (nonatomic, strong) NSFont *font;

- (CGFloat)lineHeight;

@end
