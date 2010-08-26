//
//  CLFileUpload.m
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import "CLFileUpload.h"
#import "NSString+NPMimeType.h"
#import "ASIFormDataRequest.h"

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

- (ASIHTTPRequest *)requestForURL:(NSURL *)theURL {
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[theURL URLByAppendingPathComponent:@"items/new"]];
	return request;
}

- (ASIHTTPRequest *)s3RequestForURL:(NSURL *)theURL parameterDictionary:(NSDictionary *)paramsDict {
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:theURL];
	[request setRequestMethod:@"POST"];
	for (NSString *currKey in [paramsDict allKeys]) {
		[request addPostValue:[paramsDict objectForKey:currKey] forKey:currKey];
	}
	[request addData:self.data withFileName:self.name andContentType:[self.name mimeType] forKey:@"file"];
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
	NSLog(@"Dealloc!");
	self.data = nil;
	[super dealloc];
}

@end
