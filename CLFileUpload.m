//
//  CLFileUpload.m
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import "CLFileUpload.h"
#import "NSMutableURLRequest+NPPOSTBody.h"
#import "NSString+NPMimeType.h"

@implementation CLFileUpload
@synthesize data;

- (id)initWithName:(NSString *)theName {
	return [self initWithName:theName data:nil];
}

- (id)initWithName:(NSString *)theName data:(NSData *)theData {
	if (self = [super initWithName:theName]) {
		self.data = theData;
	}
	return self;
}

+ (CLFileUpload *)fileUploadWithName:(NSString *)theName data:(NSData *)theData {
	return [[[[self class] alloc] initWithName:theName data:theData] autorelease];
}

- (NSMutableURLRequest *)requestForURL:(NSURL *)theURL {
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[theURL URLByAppendingPathComponent:@"items/new"]];
	[request setHTTPMethod:@"GET"];
	[request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
	return request;
}

- (NSMutableURLRequest *)s3RequestForURL:(NSURL *)theURL parameterDictionary:(NSDictionary *)paramsDict {
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:theURL];
	[request setHTTPMethod:@"POST"];
	[request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", NPHTTPBoundary] forHTTPHeaderField:@"Content-Type"];
	for (NSString *currKey in [paramsDict allKeys]) {
		[request addToHTTPBodyValue:[paramsDict objectForKey:currKey] forKey:currKey];
	}
	[request addToHTTPBodyFileData:self.data fileName:self.name mimeType:[self.name mimeType] forKey:@"file"];
	[request finalizeHTTPBody];
	return request;
}

- (BOOL)isValid {
	return self.name != nil && [self.name length] > 0 && self.data != nil && [self.data length] > 0;
}

- (NSUInteger)size {
	return [[self.name dataUsingEncoding:NSUTF8StringEncoding] length] + [self.data length];
}

- (BOOL)usesS3 {
	return YES;
}

#pragma mark -
#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
	return [[[self class] alloc] initWithName:self.name data:self.data];
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc {
	self.data = nil;
	[super dealloc];
}

@end
