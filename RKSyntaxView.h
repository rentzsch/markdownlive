//
//  RKSyntaxView.h
//  
//
//  Created by Vojto Rinik on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


@interface RKSyntaxView : NSTextView {
    NSDictionary *_scheme;
    NSDictionary *_syntax;
    
    NSMutableAttributedString *_content;
}

@property (retain) NSDictionary *scheme;
@property (retain) NSDictionary *syntax;
@property (retain) NSMutableAttributedString *content;

- (void) _setup;

#pragma mark - Handling text change
- (void) _textDidChange:(NSNotification *)notif;

#pragma mark - Highlighting
- (void) highlight;
- (void) highlightRange:(NSRange)range;

#pragma mark - Scheme
- (void) loadScheme:(NSString *)schemeFilename;
- (NSColor *) _colorFor:(NSString *)key;
- (NSFont *) _font;
- (NSFont *) _fontOfSize:(NSInteger)size bold:(BOOL)wantsBold;

#pragma mark - Syntax
- (void) loadSyntax:(NSString *)syntaxFilename;

#pragma mark - Changing text attributes
- (void) _setTextColor:(NSColor *)color range:(NSRange)range;
- (void) _setBackgroundColor:(NSColor *)color range:(NSRange)range;
- (void) _setFont:(NSFont *)font range:(NSRange)range;
- (void) _reflect;

@end
