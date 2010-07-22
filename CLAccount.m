//
//  CLAccount.m
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import "CLAccount.h"

static NSString * const CLAccountUploadCountLimitKey = @"CLAccountUploadCountLimitKey";
static NSString * const CLAccountUploadBytesLimitKey = @"CLAccountUploadBytesLimitKey";
static NSString * const CLAccountUploadsArePrivateKey = @"CLAccountUploadsArePrivateKey";
static NSString * const CLAccountEmailAddressKey = @"CLAccountEmailAddressKey";
static NSString * const CLAccountTypeKey = @"CLAccountTypeKey";

@implementation CLAccount
@synthesize uploadCountLimit, uploadBytesLimit, uploadsArePrivate, emailAddress, type;

- (id)init {
	return [self initWithEmailAddress:nil];
}

- (id)initWithEmailAddress:(NSString *)anEmail {
	if (self = [super init]) {
		self.emailAddress = anEmail;
	}
	return self;
}

+ (CLAccount *)accountWithEmailAddress:(NSString *)anEmail {
	return [[[[self class] alloc] initWithEmailAddress:anEmail] autorelease];
}

#pragma mark -
#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
	CLAccount *theAccount = [[[self class] alloc] initWithEmailAddress:self.emailAddress];
	theAccount.uploadBytesLimit = self.uploadBytesLimit;
	theAccount.uploadCountLimit = self.uploadCountLimit;
	theAccount.uploadsArePrivate = self.uploadsArePrivate;
	theAccount.type = self.type;
	return theAccount;
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		if ([decoder allowsKeyedCoding]) {
			uploadCountLimit = [decoder decodeIntegerForKey:CLAccountUploadCountLimitKey];
			uploadBytesLimit = [[decoder decodeObjectForKey:CLAccountUploadBytesLimitKey] unsignedIntegerValue];
			uploadsArePrivate = [decoder decodeBoolForKey:CLAccountUploadsArePrivateKey];
			emailAddress = [decoder decodeObjectForKey:CLAccountEmailAddressKey];
			type = [decoder decodeIntegerForKey:CLAccountTypeKey];
		}
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	if ([encoder allowsKeyedCoding]) {
		[encoder encodeInteger:self.uploadCountLimit forKey:CLAccountUploadCountLimitKey];
		[encoder encodeObject:[NSNumber numberWithUnsignedInteger:self.uploadBytesLimit] forKey:CLAccountUploadBytesLimitKey];
		[encoder encodeBool:self.uploadsArePrivate forKey:CLAccountUploadsArePrivateKey];
		[encoder encodeObject:self.emailAddress forKey:CLAccountEmailAddressKey];
		[encoder encodeInteger:self.type forKey:CLAccountTypeKey];
	}
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc {
	
	[super dealloc];
}

@end
