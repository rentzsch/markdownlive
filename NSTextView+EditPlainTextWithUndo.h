//
//  NSTextView+EditPlainTextWithUndo.h
//  MarkdownLive
//
//  Created by Jan Weiß on 31.08.12. Some rights reserved: <http://opensource.org/licenses/mit-license.php>
//

// Based on DrewThaler’s post at http://www.cocoadev.com/index.pl?UndoSupportForNSTextStorage

#import <Foundation/Foundation.h>


@interface NSTextView (EditPlainTextWithUndo)

- (void)setSelectedRangeWithUndo:(NSRange)range;
- (void)setSelectedRangesWithUndo:(NSArray *)ranges;

- (BOOL)setText:(NSString *)string;
- (BOOL)replaceCharactersInRange:(NSRange)range withText:(NSString *)string;
- (BOOL)insertText:(NSString *)string atIndex:(NSUInteger)index;
- (BOOL)insertText:(NSString *)string atIndex:(NSUInteger)index checkIndex:(BOOL)checkIndex;
- (BOOL)insertText:(NSString *)string;

@end
