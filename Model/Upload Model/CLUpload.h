//
//  CLUpload.h
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CLUpload : NSObject<NSCopying> {
	NSString *name;
}

@property (copy, readwrite) NSString *name;

- (id)initWithName:(NSString *)theName;

- (NSMutableURLRequest *)requestForURL:(NSURL *)theURL;
- (NSMutableURLRequest *)s3RequestForURL:(NSURL *)theURL parameterDictionary:(NSDictionary *)paramsDict;
- (BOOL)isValid;
- (NSUInteger)size; //The size in bytes
- (BOOL)usesS3;

@end
