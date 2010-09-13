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

- (void)addToHTTPBodyValue:(NSString *)theValue forKey:(NSString *)theKey {
	NSMutableData *postBody = [NSMutableData dataWithData:[self HTTPBody]];
	
	if ([postBody length] == 0)
		[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", NPHTTPBoundary] dataUsingEncoding:NSUTF8StringEncoding]];

    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", theKey] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[theValue dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", NPHTTPBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [self setHTTPBody:postBody];
}

- (void)addToHTTPBodyFileData:(NSData *)someData fileName:(NSString *)aName mimeType:(NSString *)aMimeType forKey:(NSString *)aKey {
	if (aName == nil ||[aName length] == 0)
		aName = @"UnknownFileName";
	
	if (aMimeType == nil || [aMimeType length] == 0)
		aMimeType = @"application/octet-stream";
	
	NSMutableData *postBody = [NSMutableData dataWithData:[self HTTPBody]];
	
	if ([postBody length] == 0)
		[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", NPHTTPBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", aKey, aName] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", aMimeType] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:someData];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", NPHTTPBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[self setHTTPBody:postBody];
}

- (void)finalizeHTTPBody {
	NSData *smallerData = [[self HTTPBody] subdataWithRange:NSMakeRange([[self HTTPBody] length] - 2, 2)];
	NSString *stringValue = [[NSString alloc] initWithData:smallerData encoding:NSUTF8StringEncoding];
    if ([stringValue hasSuffix:@"\r\n"]) {
        NSMutableData *tempData = [NSMutableData dataWithData:[[self HTTPBody] subdataWithRange:NSMakeRange(0, [[self HTTPBody] length] - 2)]];
		[tempData appendData:[@"--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [self setHTTPBody:tempData];
    }
	[stringValue release];
}


@end
