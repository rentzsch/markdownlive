//
//  TCLayoutManager.m
//  MarkdownLive
//
//  Created by Akihiro Noguchi on 7/05/11.
//  Copyright 2011 Aki. All rights reserved.
//

#import "EditPaneLayoutManager.h"
#import "EditPaneTypesetter.h"


@implementation EditPaneLayoutManager

@synthesize font;

- (id)init {
	if ((self = [super init])) {
		EditPaneTypesetter *typeSetter = [[EditPaneTypesetter alloc] init];
		[self setTypesetter:typeSetter];
		[self setUsesFontLeading:NO];
	}
	return self;
}


- (CGFloat)lineHeight {
	return floor([self defaultLineHeightForFont:font] + 1.5);
}

- (void)setLineFragmentRect:(NSRect)inFragmentRect forGlyphRange:(NSRange)inGlyphRange
				   usedRect:(NSRect)inUsedRect {
	inFragmentRect.size.height = [self lineHeight];
	inUsedRect.size.height = [self lineHeight];

	(void)[super setLineFragmentRect:(NSRect)inFragmentRect
					   forGlyphRange:(NSRange)inGlyphRange
							usedRect:(NSRect)inUsedRect];
}

- (void)setExtraLineFragmentRect:(NSRect)inFragmentRect usedRect:(NSRect)inUsedRect
				   textContainer:(NSTextContainer *)inTextContainer {
	inFragmentRect.size.height = [self lineHeight];
	[super setExtraLineFragmentRect:inFragmentRect usedRect:inUsedRect
					  textContainer:inTextContainer];
}

- (NSPoint)locationForGlyphAtIndex:(NSUInteger)inGlyphIndex {
	NSPoint outPoint = [super locationForGlyphAtIndex:inGlyphIndex];
	outPoint.y = [font pointSize];
	return outPoint;
}

@end
