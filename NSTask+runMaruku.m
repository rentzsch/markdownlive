#import "NSTask+runMaruku.h"

@implementation NSTask (runMaruku)

+ (NSString*)runMarukuWithInput:(NSString*)input_ error:(NSError**)error_ {
    NSString *result = nil;
    NSError *error = nil;
    
    NSString *appResourcePath = [[NSBundle mainBundle] resourcePath];
    
    NSArray *resources = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:appResourcePath
                                                                             error:&error];
    
    NSString *marukuDist = nil;
    if (!error) {
        for (NSString *resource in resources) {
            if ([resource hasPrefix:@"maruku-"]) {
                marukuDist = [appResourcePath stringByAppendingPathComponent:resource];
                break;
            }
        }
        if (!marukuDist) {
			error = [NSError errorWithDomain:NSCocoaErrorDomain
										  code:NSFileNoSuchFileError
									  userInfo:[NSDictionary dictionaryWithObject:[appResourcePath stringByAppendingPathComponent:@"maruku-*"]
																		   forKey:NSFilePathErrorKey]];
        }
    }
    
    if (!error) {
        NSString *marukuBin = [marukuDist stringByAppendingPathComponent:@"bin/maruku"];
        NSString *marukuLib = [marukuDist stringByAppendingPathComponent:@"lib"];
        
        //--
        NSPipe *inputPipe = [NSPipe pipe];
		NSPipe *outputPipe = [NSPipe pipe];
		NSPipe *errorPipe = [NSPipe pipe];
		
		NSTask *scriptTask = [[[NSTask alloc] init] autorelease];
		[scriptTask setLaunchPath:@"/usr/bin/ruby"];
		[scriptTask setArguments:[NSArray arrayWithObject:marukuBin]];
        [scriptTask setCurrentDirectoryPath:marukuLib];
		[scriptTask setStandardInput:inputPipe];
		[scriptTask setStandardOutput:outputPipe];
        [scriptTask setStandardError:errorPipe];
		[scriptTask launch];
		
		NS_DURING
            [[inputPipe fileHandleForWriting] writeData:[input_ dataUsingEncoding:NSUTF8StringEncoding]];
		NS_HANDLER
            //	Catch Broken pipe exceptions in case the script for some reason doesn't read its STDIN.
		NS_ENDHANDLER
		[[inputPipe fileHandleForWriting] closeFile];
		result = [[[NSString alloc] initWithData:[[outputPipe fileHandleForReading] readDataToEndOfFile]
										encoding:NSUTF8StringEncoding] autorelease];
    }
    
    if (error_ && error) *error_ = error;
    return result;
}

@end
