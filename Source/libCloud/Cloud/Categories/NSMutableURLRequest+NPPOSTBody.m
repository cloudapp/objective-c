//
//  NSMutableURLRequest+NPPOSTBody.m
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import "NSMutableURLRequest+NPPOSTBody.h"


NSString * const NPHTTPBoundary = @"-----NPRequestBoundary-----";


@implementation NSMutableURLRequest (NPPOSTBody)

- (void)addToHTTPBodyValue:(NSString *)theValue forKey:(NSString *)theKey
{
	NSMutableData *postBody = [NSMutableData dataWithData:[self HTTPBody]];
	
	if ([postBody length] == 0) {
        // Add opening boundary
        NSString *boundary = [NSString stringWithFormat:@"--%@\r\n", NPHTTPBoundary];
		[postBody appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // Content disposition
    NSString *contentDisposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", theKey];
    [postBody appendData:[contentDisposition dataUsingEncoding:NSUTF8StringEncoding]];
    
    // The actual value
    [postBody appendData:[theValue dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Separating boundary
    NSString *boundary = [NSString stringWithFormat:@"\r\n--%@\r\n", NPHTTPBoundary];
    [postBody appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self setHTTPBody:postBody];
}

- (void)addToHTTPBodyFileData:(NSData *)someData fileName:(NSString *)aName mimeType:(NSString *)aMimeType forKey:(NSString *)aKey
{
    // Fallbacks
	if (aName == nil ||[aName length] == 0)
		aName = @"UnknownFileName";
	
	if (aMimeType == nil || [aMimeType length] == 0)
		aMimeType = @"application/octet-stream";
	
    // Get existing body
	NSMutableData *postBody = [NSMutableData dataWithData:[self HTTPBody]];
	
	if ([postBody length] == 0) {
        // Add opening boundary
        NSString *boundary = [NSString stringWithFormat:@"--%@\r\n", NPHTTPBoundary];
		[postBody appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
    }
	
    // Content disposition
    NSString *contentDisposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", aKey, aName];
	[postBody appendData:[contentDisposition dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Content type
    NSString *contentType = [NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", aMimeType];
	[postBody appendData:[contentType dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Append actual data
	[postBody appendData:someData];
    
    // Separating boundary
    NSString *boundary = [NSString stringWithFormat:@"\r\n--%@\r\n", NPHTTPBoundary];
	[postBody appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
    
	[self setHTTPBody:postBody];
}

- (void)finalizeHTTPBody
{
	NSData *smallerData = [[self HTTPBody] subdataWithRange:NSMakeRange([[self HTTPBody] length] - 2, 2)];
	NSString *stringValue = [[NSString alloc] initWithData:smallerData encoding:NSUTF8StringEncoding];
    if ([stringValue hasSuffix:@"\r\n"]) {
        // Transform last separating boundary into ending boundary
        NSData *subdata = [[self HTTPBody] subdataWithRange:NSMakeRange(0, [[self HTTPBody] length] - 2)];
        NSMutableData *mutableSubdata = [NSMutableData dataWithData:subdata];
		[mutableSubdata appendData:[@"--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [self setHTTPBody:mutableSubdata];
    }
	[stringValue release];
}

@end
