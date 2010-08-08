//
//  CLRedirectUpload.m
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import "CLRedirectUpload.h"
#import "NSMutableURLRequest+NPPOSTBody.h"

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

- (NSMutableURLRequest *)requestForURL:(NSURL *)theURL {
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[theURL URLByAppendingPathComponent:@"items"]];
	[request setHTTPMethod:@"POST"];
	[request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", NPHTTPBoundary] forHTTPHeaderField:@"Content-Type"];
	[request addToHTTPBodyValue:[[self URL] absoluteString] forKey:@"item[redirect_url]"];
	[request addToHTTPBodyValue:self.name forKey:@"item[name]"];
	[request finalizeHTTPBody];
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
