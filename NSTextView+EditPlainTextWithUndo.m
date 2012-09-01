//
//  NSTextView+EditPlainTextWithUndo.m
//  MarkdownLive
//
//  Created by Jan Weiß on 31.08.12. Some rights reserved: <http://opensource.org/licenses/mit-license.php>
//

// Based on DrewThaler’s post at http://www.cocoadev.com/index.pl?UndoSupportForNSTextStorage

#import "NSTextView+EditPlainTextWithUndo.h"


@implementation NSTextView (EditPlainTextWithUndo)

- (void)setSelectedRangeWithUndo:(NSRange)range;
{
	[self setSelectedRange:range];
	[[self.undoManager prepareWithInvocationTarget:self] setSelectedRangeWithUndo:range];
}

- (void)setSelectedRangesWithUndo:(NSArray *)ranges;
{
	[self setSelectedRanges:ranges];
	[[self.undoManager prepareWithInvocationTarget:self] setSelectedRangesWithUndo:ranges];
}

- (BOOL)setText:(NSString *)string;
{
	[[self.undoManager prepareWithInvocationTarget:self] setSelectedRangeWithUndo:self.selectedRange];

	NSTextStorage *textStorage = [self textStorage];
	
	if ([self shouldChangeTextInRange:NSMakeRange(0, [textStorage length])
					replacementString:string]) {
		
		[textStorage.mutableString setString:string];
		
		[self didChangeText];

		[self setSelectedRangeWithUndo:NSMakeRange(0, 0)];
		
		return YES;
	}
	else {
		return NO;
	}
}

- (BOOL)replaceCharactersInRange:(NSRange)range withText:(NSString *)string;
{
	NSString *selectedText = [[self string] substringWithRange:range];
	NSString *stringForDelegate = string;
	
	// If only attributes are changing, pass nil.
	if ([string isEqualToString:selectedText]) {
		stringForDelegate = nil;
	}
	
	[[self.undoManager prepareWithInvocationTarget:self] setSelectedRangeWithUndo:self.selectedRange];

	// Call delegate methods to force undo recording
	if ([self shouldChangeTextInRange:range
					replacementString:stringForDelegate]) {

		[self.textStorage.mutableString replaceCharactersInRange:range
								withString:string];

		[self didChangeText];

		[self setSelectedRangeWithUndo:NSMakeRange(range.location + [string length], 0)];
		
		return YES;
	}
	else {
		return NO;
	}
}

- (BOOL)insertText:(NSString *)string atIndex:(NSUInteger)index;
{
	NSRange range = NSMakeRange(index, 0);
	return [self replaceCharactersInRange:range withText:string];
}

- (BOOL)insertText:(NSString *)attributedString atIndex:(NSUInteger)index checkIndex:(BOOL)checkIndex;
{
	NSUInteger textLength = [self.textStorage length];

	if (checkIndex && (index == NSNotFound || !(index <= textLength))) {
		index = textLength; // AFTER the last character in textStorage
	}
	
	return [self insertText:attributedString atIndex:index];
}

- (BOOL)insertText:(NSString *)attributedString;
{
	NSRange range = [self selectedRange];
	return [self replaceCharactersInRange:range withText:attributedString];
}

@end
