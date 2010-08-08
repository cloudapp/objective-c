//
//  CLUpload.m
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import "CLUpload.h"


@implementation CLUpload
@synthesize name;

- (id)init {
	return [self initWithName:nil];
}

- (id)initWithName:(NSString *)theName {
	if (self = [super init]) {
		self.name = theName;
	}
	return self;
}

- (NSMutableURLRequest *)requestForURL:(NSURL *)theURL {
	return nil;
}

- (NSMutableURLRequest *)s3RequestForURL:(NSURL *)theURL parameterDictionary:(NSDictionary *)paramsDict {
	return nil;
}

- (BOOL)isValid {
	return NO;
}

- (NSUInteger)size {
	return 0;
}

- (BOOL)usesS3 {
	return NO;
}

#pragma mark -
#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
	return [[[self class] alloc] initWithName:nil];
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc {
	self.name = nil;
	[super dealloc];
}

@end