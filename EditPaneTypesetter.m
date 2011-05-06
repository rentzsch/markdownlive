//
//  TCTypeSetter.m
//  MarkdownLive
//
//  Created by Akihiro Noguchi on 7/05/11.
//  Copyright 2011 Aki. All rights reserved.
//

#import "EditPaneTypesetter.h"
#import "EditPaneLayoutManager.h"


@implementation EditPaneTypesetter

- (id)init {
	if ((self = [super init])) {
		[self setUsesFontLeading:YES];
	}
	return self;
}

- (CGFloat)lineSpacingAfterGlyphAtIndex:(NSUInteger)inGlyphIndex
		   withProposedLineFragmentRect:(NSRect)inRect {
	EditPaneLayoutManager *theManager = (EditPaneLayoutManager *)[self layoutManager];
	CGFloat theDefaultLineHeight = [theManager defaultLineHeightForFont:theManager.font];
	return floor(theDefaultLineHeight - inRect.size.height + 1.5);
}

@end
