#import <Cocoa/Cocoa.h>

@interface NSTask (runScriptNamed)
+ (NSString*)runScriptNamed:(NSString*)scriptName_ extension:(NSString*)scriptExtension_ input:(NSString*)input_ error:(NSError**)error_;
@end
