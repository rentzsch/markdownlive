/*
 * Copyright (c) 2007-2008 Dave Dribin
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import "DDTemporaryDirectory.h"
#include <unistd.h>
#import "JRLog.h"


@implementation DDTemporaryDirectory

+ (DDTemporaryDirectory *) temporaryDirectory;
{
    return [[[self alloc] init] autorelease];
}

- (id) init;
{
    self = [super init];
    if (self == nil)
        return nil;
    
    NSString * tempDir = NSTemporaryDirectory();
    if (tempDir == nil)
        tempDir = @"/tmp";
    
    NSString * template = [tempDir stringByAppendingPathComponent: @"temp.XXXXXX"];
    JRLogDebug(@"Template: %@", template);
    const char * fsTemplate = [template fileSystemRepresentation];
    NSMutableData * bufferData = [NSMutableData dataWithBytes: fsTemplate
                                                       length: strlen(fsTemplate)+1];
    char * buffer = [bufferData mutableBytes];
    JRLogDebug(@"FS Template: %s", buffer);
    char * result = mkdtemp(buffer);
    NSString * temporaryDirectory = [[NSFileManager defaultManager]
            stringWithFileSystemRepresentation: buffer
                                        length: strlen(buffer)];
    if (result == NULL)
    {
        JRLogWarn(@"Could not create temporary dir: %@, %s", temporaryDirectory,
                  strerror(errno));
        [self release];
        return nil;
    }
    
    mFullPath = [temporaryDirectory retain];
    
    return self;
}

//=========================================================== 
// dealloc
//=========================================================== 
- (void) dealloc
{
    [self cleanup];
    [mFullPath release];
    
    mFullPath = nil;
    [super dealloc];
}

- (void) cleanup;
{
    [[NSFileManager defaultManager] removeFileAtPath: mFullPath
                                             handler: nil];
}

- (NSString *) fullPath;
{
    return mFullPath;
}

@end
