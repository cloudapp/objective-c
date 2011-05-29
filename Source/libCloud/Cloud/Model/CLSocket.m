//
//  CLSocket.m
//  Cloud
//
//  Created by Matthias Plappert on 20.02.11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import "CLSocket.h"


NSString *const CLSocketItemsChannel = @"items";

static NSString *const CLSocketAPIKeyKey   = @"CLSocketAPIKeyKey";
static NSString *const CLSocketAppIDKey    = @"CLSocketAppIDKey";
static NSString *const CLSocketAuthURLKey  = @"CLSocketAuthURLKey";
static NSString *const CLSocketChannelsKey = @"CLSocketChannelsKey";


@implementation CLSocket

@synthesize APIKey = _APIKey, appID = _appID, authURL = _authURL, channels = _channels;

- (id)init
{
	if ((self = [super init])) {
		_APIKey    = nil;
		_appID     = NSNotFound;
		_authURL   = nil;
		_channels  = nil;
	}
	return self;
}

#pragma mark -
#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
	CLSocket *theSocket = [[[self class] alloc] init];
	theSocket.APIKey    = self.APIKey;
	theSocket.appID     = self.appID;
	theSocket.authURL   = self.authURL;
	theSocket.channels  = self.channels;
	
	return theSocket;
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init])) {
		if ([decoder allowsKeyedCoding]) {
			_APIKey   = [[decoder decodeObjectForKey:CLSocketAPIKeyKey] retain];
			_appID    = [decoder decodeIntegerForKey:CLSocketAppIDKey];
			_authURL  = [[decoder decodeObjectForKey:CLSocketAuthURLKey] retain];
			_channels = [[decoder decodeObjectForKey:CLSocketChannelsKey] retain];
		}
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	if ([encoder allowsKeyedCoding]) {
		[encoder encodeObject:self.APIKey forKey:CLSocketAPIKeyKey];
		[encoder encodeInteger:self.appID forKey:CLSocketAppIDKey];
		[encoder encodeObject:self.authURL forKey:CLSocketAuthURLKey];
		[encoder encodeObject:self.channels forKey:CLSocketChannelsKey];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
	[_APIKey release];
    _APIKey = nil;
	[_authURL release];
    _authURL = nil;
	[_channels release];
    _channels = nil;
	
	[super dealloc];
}

@end
