//
//  CLAccount.m
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import "CLAccount.h"


static NSString * const CLAccountDomainKey            = @"CLAccountDomainKey";
static NSString * const CLAccountDomainHomepageKey    = @"CLAccountDomainHomepageKey";
static NSString * const CLAccountAlphaUserKey         = @"CLAccountAlphaUserKey";
static NSString * const CLAccountUploadsArePrivateKey = @"CLAccountUploadsArePrivateKey";
static NSString * const CLAccountEmailKey             = @"CLAccountEmailKey";
static NSString * const CLAccountExpiresAtKey         = @"CLAccountExpiresAtKey";
static NSString * const CLAccountTypeKey              = @"CLAccountTypeKey";
static NSString * const CLAccountSocketKey            = @"CLAccountSocketKey";


@implementation CLAccount

@synthesize uploadsArePrivate = _uploadsArePrivate, email = _email,
            subscriptionExpiresAt = _subscriptionExpiresAt, type = _type, domain = _domain,
            domainHomePage = _domainHomePage, alphaUser = _alphaUser, socket = _socket;

+ (id)accountWithEmail:(NSString *)anEmail
{
	return [[[[self class] alloc] initWithEmail:anEmail] autorelease];
}

- (id)init
{
	return [self initWithEmail:nil];
}

- (id)initWithEmail:(NSString *)anEmail
{
	if ((self = [super init])) {
		_email = [anEmail copy];
	}
	return self;
}

#pragma mark -
#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
	CLAccount *theAccount = [[[self class] alloc] initWithEmail:self.email];
	theAccount.domain                = self.domain;
	theAccount.domainHomePage        = self.domainHomePage;
	theAccount.alphaUser             = self.alphaUser;
	theAccount.uploadsArePrivate     = self.uploadsArePrivate;
    theAccount.subscriptionExpiresAt = self.subscriptionExpiresAt;
	theAccount.type                  = self.type;
	theAccount.socket                = self.socket;
    
	return theAccount;
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init])) {
		if ([decoder allowsKeyedCoding]) {
			_domain                = [[decoder decodeObjectForKey:CLAccountDomainKey] retain];
			_domainHomePage        = [[decoder decodeObjectForKey:CLAccountDomainHomepageKey] retain];
			_alphaUser             = [decoder decodeBoolForKey:CLAccountAlphaUserKey];
			_uploadsArePrivate     = [decoder decodeBoolForKey:CLAccountUploadsArePrivateKey];
			_email                 = [[decoder decodeObjectForKey:CLAccountEmailKey] retain];
            _subscriptionExpiresAt = [[decoder decodeObjectForKey:CLAccountExpiresAtKey] retain];
			_type                  = [decoder decodeIntegerForKey:CLAccountTypeKey];
			_socket                = [[decoder decodeObjectForKey:CLAccountSocketKey] retain];
		}
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	if ([encoder allowsKeyedCoding]) {
		[encoder encodeBool:self.alphaUser forKey:CLAccountAlphaUserKey];
		[encoder encodeObject:self.domain forKey:CLAccountDomainKey];
		[encoder encodeObject:self.domainHomePage forKey:CLAccountDomainHomepageKey];
		[encoder encodeBool:self.uploadsArePrivate forKey:CLAccountUploadsArePrivateKey];
		[encoder encodeObject:self.email forKey:CLAccountEmailKey];
        [encoder encodeObject:self.subscriptionExpiresAt forKey:CLAccountExpiresAtKey];
		[encoder encodeInteger:self.type forKey:CLAccountTypeKey];
		[encoder encodeObject:self.socket forKey:CLAccountSocketKey];
	}
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc
{
    [_email release];
	_email = nil;
    [_domain release];
	_domain = nil;
    [_domainHomePage release];
    _domainHomePage = nil;
    [_subscriptionExpiresAt release];
    _subscriptionExpiresAt = nil;
	[_socket release];
    _socket = nil;
	
	[super dealloc];
}

@end
