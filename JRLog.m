/*******************************************************************************
	JRLog.m
		Copyright (c) 2006-2007 Jonathan 'Wolf' Rentzsch: <http://rentzsch.com>
		Some rights reserved: <http://opensource.org/licenses/mit-license.php>

	***************************************************************************/

#import "JRLog.h"
#include <unistd.h>

#if JRLogOverrideNSLog
id self = nil;
#endif
#undef NSLog

//
//	Globals
//
#pragma mark Globals

BOOL		gLoadedJRLogSettings = NO;
JRLogLevel	gDefaultJRLogLevel = JRLogLevel_Debug;

//
//
//

@protocol JRLogDestinationDO
- (oneway void)logWithDictionary:(bycopy NSDictionary*)dictionary_;
@end

@interface JRLogOutput : NSObject <JRLogLogger> {
	NSString				*sessionUUID;
	BOOL					tryDO;
	id<JRLogDestinationDO>	destination;
}
+ (id)sharedOutput;
- (void)destinationDOAvailable:(NSNotification*)notification_;
@end
@implementation JRLogOutput
+ (id)sharedOutput {
	static JRLogOutput *output = nil;
	if (!output) {
		output = [[JRLogOutput alloc] init];
	}
	return output;
}
- (id)init {
	self = [super init];
	if (self) {
		sessionUUID = (id)CFUUIDCreateString(kCFAllocatorDefault, CFUUIDCreate(kCFAllocatorDefault));
		[[NSDistributedNotificationCenter defaultCenter] addObserver:self
															selector:@selector(destinationDOAvailable:)
																name:@"JRLogDestinationDOAvailable"
															  object:nil];
		tryDO = YES;
	}
	return self;
}

- (void)destinationDOAvailable:(NSNotification*)notification_ {
	tryDO = YES;
}

- (void)logWithLevel:(JRLogLevel)callerLevel_
			instance:(NSString*)instance_
				file:(const char*)file_
				line:(unsigned)line_
			function:(const char*)function_
			 message:(NSString*)message_
{
	if (tryDO) {
		tryDO = NO;
		destination = [[NSConnection rootProxyForConnectionWithRegisteredName:@"JRLogDestinationDO" host:nil] retain];
	}
	if (destination) {
		NS_DURING
			[destination logWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
				[[NSBundle mainBundle] bundleIdentifier], @"bundleID",
				sessionUUID, @"sessionUUID",
				[NSNumber numberWithLong:getpid()], @"pid",
				[NSDate date], @"date",
				[NSNumber numberWithInt:callerLevel_], @"level",
				instance_, @"instance",
				[NSString stringWithUTF8String:file_], @"file",
				[NSNumber numberWithUnsignedInt:line_], @"line",
				[NSString stringWithUTF8String:function_], @"function",
				message_, @"message",
				nil]];
		NS_HANDLER
			if ([[localException name] isEqualToString:NSObjectInaccessibleException]) {
				destination = nil;
			} else {
				[localException raise];
			}
		NS_ENDHANDLER
	} else {
		// "MyClass.m:123: blah blah"
		NSLog(@"%@:%u: %@",
			  [[NSString stringWithUTF8String:file_] lastPathComponent],
			  line_,
			  message_);
	}
}
@end

//
//
//

static JRLogLevel parseJRLogLevel(NSString *level_) {
	static NSDictionary *levelLookup = nil;
	if (!levelLookup) {
		levelLookup = [NSDictionary dictionaryWithObjectsAndKeys:
			[NSNumber numberWithInt:JRLogLevel_Debug], @"debug",
			[NSNumber numberWithInt:JRLogLevel_Info], @"info",
			[NSNumber numberWithInt:JRLogLevel_Warn], @"warn",
			[NSNumber numberWithInt:JRLogLevel_Error], @"error",
			[NSNumber numberWithInt:JRLogLevel_Fatal], @"fatal",
			[NSNumber numberWithInt:JRLogLevel_Off], @"off",
			nil];
	}
	NSNumber *result = [levelLookup objectForKey:[level_ lowercaseString]];
	return result ? [result intValue] : JRLogLevel_UNSET;
}

static void LoadJRLogSettings() {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	//	Load+interpret the Info.plist-based settings.
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[[NSBundle mainBundle] infoDictionary]];
	[settings addEntriesFromDictionary:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
	
	NSArray *keys = [settings allKeys];
	unsigned keyIndex = 0, keyCount = [keys count];
	for(; keyIndex < keyCount; keyIndex++) {
		NSString *key = [keys objectAtIndex:keyIndex];
		if ([key hasPrefix:@"JRLogLevel"]) {
			JRLogLevel level = parseJRLogLevel([settings objectForKey:key]);
			if (JRLogLevel_UNSET == level) {
				NSLog(@"JRLog: can't parse \"%@\" JRLogLevel value for key \"%@\"", [settings objectForKey:key], key);
			} else {
				NSArray *keyNames = [key componentsSeparatedByString:@"."];
				if ([keyNames count] == 2) {
					//	It's a pseudo-keypath: JRLogLevel.MyClassName.
					Class c = NSClassFromString([keyNames lastObject]);
					if (c) {
						[c setClassJRLogLevel:level];
					} else {
						NSLog(@"JRLog: unknown class \"%@\"", [keyNames lastObject]);
					}
				} else {
					//	Just a plain "JRLogLevel": it's for the default level.
					[NSObject setDefaultJRLogLevel:level];
				}
			}
		}
	}
	
	[pool release];
}

BOOL IsJRLogLevelActive(id self_, JRLogLevel callerLevel_) {
	assert(callerLevel_ >= JRLogLevel_Debug && callerLevel_ <= JRLogLevel_Fatal);
	
	if (!gLoadedJRLogSettings) {
		gLoadedJRLogSettings = YES;
		LoadJRLogSettings();
	}
	
	//	Setting the default level to OFF disables all logging, regardless of everything else.
	if (JRLogLevel_Off == gDefaultJRLogLevel)
		return NO;
	
	JRLogLevel currentLevel;
	if (self_) {
		currentLevel = [[self_ class] classJRLogLevel];
		if (JRLogLevel_UNSET == currentLevel) { 
			currentLevel = gDefaultJRLogLevel;
		}
	} else {
		currentLevel = gDefaultJRLogLevel;
		// TODO It would be cool if we could use the file's name was a symbol to set logging levels for JRCLog... functions.
	}
	
	return callerLevel_ >= currentLevel;
}

	void
JRLog(
	id			self_,
	JRLogLevel	callerLevel_,
	unsigned	line_,
	const char	*file_,
	const char	*function_,
	NSString	*format_,
	...)
{
    assert(callerLevel_ >= JRLogLevel_Debug && callerLevel_ <= JRLogLevel_Fatal);
    assert(file_);
    assert(function_);
    assert(format_);
	
	//	
	va_list args;
	va_start(args, format_);
	NSString *message = [[[NSString alloc] initWithFormat:format_ arguments:args] autorelease];
	va_end(args);
	
    id<JRLogLogger> logger = [JRLogOutput JRLogLogger];
	[logger logWithLevel:callerLevel_
                instance:self_ ? [NSString stringWithFormat:@"<%@: %p>", [self_ className], self_] : @"nil"
                    file:file_
                    line:line_
                function:function_
                 message:message];
	
	if (JRLogLevel_Fatal == callerLevel_) {
		exit(0);
	}
}

@implementation NSObject (JRLogAdditions)

NSMapTable *gClassLoggingLevels = NULL;
+ (void)load {
	if (!gClassLoggingLevels) {
#if MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5
        gClassLoggingLevels = NSCreateMapTable(NSIntMapKeyCallBacks, NSIntMapValueCallBacks, 32);
#else
        gClassLoggingLevels = NSCreateMapTable(NSIntegerMapKeyCallBacks, NSIntegerMapValueCallBacks, 32);
#endif
	}
}

+ (JRLogLevel)classJRLogLevel {
	void *mapValue = NSMapGet(gClassLoggingLevels, self);
	if (mapValue) {
		return (JRLogLevel)mapValue;
	} else {
		Class superclass = [self superclass];
		return superclass ? [superclass classJRLogLevel] : JRLogLevel_UNSET;
	}
}

+ (void)setClassJRLogLevel:(JRLogLevel)level_ {
	if (JRLogLevel_UNSET == level_) {
		NSMapRemove(gClassLoggingLevels, self);
	} else {
		NSMapInsert(gClassLoggingLevels, self, (const void*)level_);
	}
}

+ (JRLogLevel)defaultJRLogLevel {
	return gDefaultJRLogLevel;
}

+ (void)setDefaultJRLogLevel:(JRLogLevel)level_ {
	assert(level_ >= JRLogLevel_Debug && level_ <= JRLogLevel_Off);
	gDefaultJRLogLevel = level_;
}

static id<JRLogLogger> sLogger = nil;

+ (void)setJRLogLogger: (id<JRLogLogger>) logger_;
{
    sLogger = logger_;
}

+ (id<JRLogLogger>)JRLogLogger;
{
    if (sLogger == nil)
        return [JRLogOutput sharedOutput];
    else
        return sLogger;
}

+ (id<JRLogLogger>)defaultJRLogLogger;
{
    return [JRLogOutput sharedOutput];
}

@end
