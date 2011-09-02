//
//  RKSyntaxView.m
//  
//
//  Created by Vojto Rinik on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RKSyntaxView.h"
#import "NSColor+HexRGB.h"

@implementation RKSyntaxView

@synthesize scheme=_scheme;
@synthesize syntax=_syntax;
@synthesize content=_content;

#pragma mark - Lifecycle

- (id)init {
    if ((self = [super init])) {
        [self _setup];
    }
    return self;
}

- (void)awakeFromNib {
    [self _setup];
}

- (void)_setup {
    self.content = [[[NSMutableAttributedString alloc] init] autorelease];
    [self setTextContainerInset:NSMakeSize(10.0, 10.0)];
    [self highlight];
    
    [self addObserver:self forKeyPath:@"string" options:0 context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textDidChange:) name:NSTextDidChangeNotification object:self];
}

- (void) dealloc {
    self.content = nil;
    [super dealloc];
}

#pragma mark - Handling text changes

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self highlight];
}

- (void)_textDidChange:(NSNotification *)notif {
    [self highlight];
}

#pragma mark - Scheme

- (void)loadScheme:(NSString *)schemeFilename {
    NSString *schemePath = [[NSBundle mainBundle] pathForResource:schemeFilename ofType:@"plist" inDirectory:nil];
    self.scheme = [NSDictionary dictionaryWithContentsOfFile:schemePath];
}

- (NSColor *) _colorFor:(NSString *)key {
    NSString *colorCode = [[self.scheme objectForKey:@"colors"] objectForKey:key];
    if (!colorCode) return nil;
    NSColor *color = [NSColor colorFromHexRGB:colorCode];
    return color;
}

- (NSFont *) _font {
    return [self _fontOfSize:12 bold:NO];
}

- (NSFont *) _fontOfSize:(NSInteger)size bold:(BOOL)wantsBold {
    NSString *fontName = [self.scheme objectForKey:@"font"];
    NSFont *font = [NSFont fontWithName:fontName size:size];
    if (!font) font = [NSFont systemFontOfSize:size];
    
    if (wantsBold) {
        NSFontTraitMask traits = NSBoldFontMask;
        NSFontManager *manager = [NSFontManager sharedFontManager];
        font = [manager fontWithFamily:fontName traits:traits weight:5.0 size:size];
    }
    
    return font;
}

#pragma mark - Syntax

- (void)loadSyntax:(NSString *)syntaxFilename {
    NSString *schemePath = [[NSBundle mainBundle] pathForResource:syntaxFilename ofType:@"plist" inDirectory:nil];
    self.syntax = [NSDictionary dictionaryWithContentsOfFile:schemePath];
}

#pragma mark - Highlighting

- (void) highlight {
    self.content = [[NSMutableAttributedString alloc] initWithString:[self string]];
    [self.content release];
    
    NSColor *background = [self _colorFor:@"background"];
    [self setBackgroundColor:background];
    [(NSScrollView *)self.superview setBackgroundColor:background];
    [self setTextColor:[self _colorFor:@"default"]];
    
    return [self highlightRange:NSMakeRange(0, [self.content length])];
}

- (void) highlightRange:(NSRange)range {
    NSColor *defaultColor = [self _colorFor:@"default"];
    NSInteger defaultSize = [(NSNumber *)[self.scheme objectForKey:@"size"] integerValue];
    if (!defaultSize) defaultSize = 12;
    NSFont *defaultFont = [self _fontOfSize:defaultSize bold:NO];
    [self _setFont:defaultFont range:range];
    [self _setTextColor:defaultColor range:range];
    [self _setBackgroundColor:[NSColor clearColor] range:range];
    
    NSString *string = [self.content string];
    
    for (NSString *type in [self.syntax allKeys]) {
        NSDictionary *params = [self.syntax objectForKey:type];
        NSString *pattern = [params objectForKey:@"pattern"];
        NSString *colorName = [params objectForKey:@"color"];
        NSColor *color = [self _colorFor:colorName];
        NSString *backgroundColorName = [params objectForKey:@"backgroundColor"];
        NSColor *backgroundColor = [self _colorFor:backgroundColorName];
        NSInteger size = [(NSNumber *)[params objectForKey:@"size"] integerValue];
        BOOL isBold = [(NSNumber *)[params objectForKey:@"isBold"] boolValue];
        NSFont *font = [self _fontOfSize:(size?size:defaultSize) bold:isBold];
        NSInteger patternGroup = [(NSNumber *)[params objectForKey:@"patternGroup"] integerValue];
        
        NSError *error = nil;
        NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive|NSRegularExpressionAnchorsMatchLines error:&error];
        NSArray *matches = [expr matchesInString:string options:0 range:range];
        for (NSTextCheckingResult *match in matches) {
            NSRange range = patternGroup ? [match rangeAtIndex:patternGroup] : [match range];
            [self _setTextColor:color range:range];
            if (backgroundColor) [self _setBackgroundColor:backgroundColor range:range];
            [self _setFont:font range:range];
        }
    }
    
    [self _reflect];
}

#pragma mark - Changing text attributes

- (void) _setTextColor:(NSColor *)color range:(NSRange)range {
    if (!color) return;
    [self.content addAttribute:NSForegroundColorAttributeName value:color range:range];
}

- (void) _setBackgroundColor:(NSColor *)color range:(NSRange)range {
    [self.content addAttribute:NSBackgroundColorAttributeName value:color range:range];
}

- (void) _setFont:(NSFont *)font range:(NSRange)range {
    [self.content addAttribute:NSFontAttributeName value:font range:range];
}

- (void) _reflect {
    NSTextStorage *storage = [self textStorage];
    NSAttributedString *content = self.content;
    NSRange range = NSMakeRange(0, [content length]);
    [content enumerateAttributesInRange:range options:0 usingBlock:^(NSDictionary *attributes, NSRange range, BOOL *stop){
        [storage setAttributes:attributes range:range];
    }];
}

@end
