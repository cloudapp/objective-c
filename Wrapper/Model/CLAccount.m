//
//  CLAccount.m
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import "CLAccount.h"

static NSString * const CLAccountDomainKey = @"CLAccountDomainKey";
static NSString * const CLAccountDomainHomepageKey = @"CLAccountDomainHomepageKey";
static NSString * const CLAccountAlphaUserKey = @"CLAccountAlphaUserKey";
static NSString * const CLAccountUploadsArePrivateKey = @"CLAccountUploadsArePrivateKey";
static NSString * const CLAccountEmailKey = @"CLAccountEmailKey";
static NSString * const CLAccountTypeKey = @"CLAccountTypeKey";

@implementation CLAccount
@synthesize uploadsArePrivate = _uploadsArePrivate, email = _email, type = _type, domain = _domain, 
			domainHomePage = _domainHomePage, alphaUser = _alphaUser;;

- (id)init {
	return [self initWithEmail:nil];
}

- (id)initWithEmail:(NSString *)anEmail {
	if ((self = [super init])) {
		self.email = anEmail;
	}
	return self;
}

+ (id)accountWithEmail:(NSString *)anEmail {
	return [[[[self class] alloc] initWithEmail:anEmail] autorelease];
}

#pragma mark -
#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
	CLAccount *theAccount = [[[self class] alloc] initWithEmail:self.email];
	theAccount.domain = self.domain;
	theAccount.domainHomePage = self.domainHomePage;
	theAccount.alphaUser = self.alphaUser;
	theAccount.uploadsArePrivate = self.uploadsArePrivate;
	theAccount.type = self.type;
	return theAccount;
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
	if ((self = [super init])) {
		if ([decoder allowsKeyedCoding]) {
			_domain = [[decoder decodeObjectForKey:CLAccountDomainKey] retain];
			_domainHomePage = [[decoder decodeObjectForKey:CLAccountDomainHomepageKey] retain];
			_alphaUser = [decoder decodeBoolForKey:CLAccountAlphaUserKey];
			_uploadsArePrivate = [decoder decodeBoolForKey:CLAccountUploadsArePrivateKey];
			_email = [[decoder decodeObjectForKey:CLAccountEmailKey] retain];
			_type = [decoder decodeIntegerForKey:CLAccountTypeKey];
		}
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	if ([encoder allowsKeyedCoding]) {
		[encoder encodeBool:self.alphaUser forKey:CLAccountAlphaUserKey];
		[encoder encodeObject:self.domain forKey:CLAccountDomainKey];
		[encoder encodeObject:self.domainHomePage forKey:CLAccountDomainHomepageKey];
		[encoder encodeBool:self.uploadsArePrivate forKey:CLAccountUploadsArePrivateKey];
		[encoder encodeObject:self.email forKey:CLAccountEmailKey];
		[encoder encodeInteger:self.type forKey:CLAccountTypeKey];
	}
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc {
	self.email = nil;
	self.domain = nil;
    self.domainHomePage = nil;
	
	[super dealloc];
}

@end
