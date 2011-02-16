//
//  NSString+NPAdditions.h
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (NPAdditions)

+ (NSString *)stringWithData:(NSData *)theData encoding:(NSStringEncoding)theEncoding;
+ (NSString *)uniqueString;

@end
