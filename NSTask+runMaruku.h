#import <Cocoa/Cocoa.h>

@interface NSTask (runMaruku)
+ (NSString*)runMarukuWithInput:(NSString*)input_ error:(NSError**)error_;
@end
