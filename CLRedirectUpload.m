//
//  CLRedirectUpload.m
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import "CLRedirectUpload.h"
#import "ASIFormDataRequest.h"

@implementation CLRedirectUpload
@synthesize URL;

- (id)initWithName:(NSString *)theName {
	return [self initWithName:theName URL:nil];
}

- (id)initWithName:(NSString *)theName URL:(NSURL *)theURL {
	if (self = [super initWithName:theName]) {
		self.URL = theURL;
	}
	return self;
}

+ (CLRedirectUpload *)redirectUploadWithName:(NSString *)theName URL:(NSURL *)theURL {
	return [[[[self class] alloc] initWithName:theName URL:theURL] autorelease];
}

- (ASIHTTPRequest *)requestForURL:(NSURL *)theURL {
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[theURL URLByAppendingPathComponent:@"items"]];
	[request setRequestMethod:@"POST"];
	[request addPostValue:[self.URL absoluteString] forKey:@"item[redirect_url]"];
	[request addPostValue:self.name forKey:@"item[name]"];
	return request;
}

- (NSString *)name {
	if ([super name] == nil || [[super name] length] == 0) {
		return [self.URL absoluteString];
	}
	return [super name];
}

- (BOOL)isValid {
	return self.name != nil && [self.name length] > 0 && self.URL != nil && [[self.URL absoluteString] length] > 0;
}

- (NSUInteger)size {
	return [[self.name dataUsingEncoding:NSUTF8StringEncoding] length] + [[[self.URL absoluteString] dataUsingEncoding:NSUTF8StringEncoding] length];
}

- (BOOL)usesS3 {
	return NO;
}

#pragma mark -
#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
	return [[[self class] alloc] initWithName:self.name URL:self.URL];
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc {
	self.URL = nil;
	[super dealloc];
}

@end
