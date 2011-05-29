//
//  NSString+NPMimeType.m
//  Cloud
//
//  Created by np101137 on 9/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSString+NPMimeType.h"
#if TARGET_OS_IPHONE
#import <MobileCoreServices/MobileCoreServices.h>
#endif


@implementation NSString (NPMimeType)

- (NSString *)mimeType
{	
	NSString *pathExtension = [self pathExtension];
	if (pathExtension == nil || [pathExtension isEqualToString:@""])
		return @"application/octet-stream";
	
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (CFStringRef)pathExtension, NULL);
    if (UTI == nil) 
		return @"application/octet-stream";
	
    CFStringRef registeredType = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType);
	if (registeredType == nil) {
		CFRelease(UTI);
		return @"application/octet-stream";
	}
	
	CFRelease(UTI);
    return [(NSString *)registeredType autorelease];
}

@end
