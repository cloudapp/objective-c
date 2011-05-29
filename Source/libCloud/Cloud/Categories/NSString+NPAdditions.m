//
//  NSString+NPAdditions.m
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import "NSString+NPAdditions.h"


@implementation NSString (NPAdditions)

+ (NSString *)stringWithData:(NSData *)theData encoding:(NSStringEncoding)theEncoding
{
	return [[[NSString alloc] initWithData:theData encoding:theEncoding] autorelease];
}

+ (NSString *)uniqueString
{
	return [[NSProcessInfo processInfo] globallyUniqueString];
}

@end