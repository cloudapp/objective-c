//
//  NSString+NPMimeType.m
//  Cloud
//
//  Created by np101137 on 9/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSString+NPMimeType.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation NSString (NPMimeType)

- (NSString *)mimeType
{
    NSString *pathExtension = [self pathExtension];
    if (pathExtension == nil || [pathExtension isEqualToString:@""])
        return @"application/octet-stream";
    
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)pathExtension, NULL);
    if (UTI == nil)
        return @"application/octet-stream";
    
    CFStringRef registeredType = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType);
    if (registeredType == nil) {
        CFRelease(UTI);
        return @"application/octet-stream";
    }
    
    CFRelease(UTI);
    return (__bridge_transfer NSString *)registeredType;
}

@end
