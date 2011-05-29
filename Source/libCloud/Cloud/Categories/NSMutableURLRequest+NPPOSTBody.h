//
//  NSMutableURLRequest+NPPOSTBody.h
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * const NPHTTPBoundary;

@interface NSMutableURLRequest (NPPOSTBody)

- (void)addToHTTPBodyValue:(NSString *)theValue forKey:(NSString *)theKey;
- (void)addToHTTPBodyFileData:(NSData *)someData fileName:(NSString *)aName mimeType:(NSString *)aMimeType forKey:(NSString *)aKey;

//Make sure to call this when you are done if you used any of the above methods
- (void)finalizeHTTPBody;

@end
