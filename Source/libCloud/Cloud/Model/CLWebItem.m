//
//  CLWebItem.m
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import "CLWebItem.h"


static NSString * const CLWebItemNameKey       = @"CLWebItemNameKey";
static NSString * const CLWebItemTypeKey       = @"CLWebItemTypeKey";
static NSString * const CLWebItemContentURLKey = @"CLWebItemContentURLKey";
static NSString * const CLWebItemURLKey        = @"CLWebItemURLKey";
static NSString * const CLWebItemMimeTypeKey   = @"CLWebItemMimeTypeKey";
static NSString * const CLWebItemViewCountKey  = @"CLWebItemViewCountKey";
static NSString * const CLWebItemRemoteURLKey  = @"CLWebItemRemoteURLKey";
static NSString * const CLWebItemHrefKey       = @"CLWebItemHrefKey";
static NSString * const CLWebItemIconURLKey    = @"CLWebItemIconURLKey";
static NSString * const CLWebItemIconKey       = @"CLWebItemIconKey";
static NSString * const CLWebItemTrashedKey    = @"CLWebItemTrashedKey";
static NSString * const CLWebItemPrivateKey    = @"CLWebItemPrivateKey";
static NSString * const CLWebItemCreatedAtKey  = @"CLWebItemCreatedAtKey";
static NSString * const CLWebItemUpdatedAtKey  = @"CLWebItemUpdatedAtKey";
static NSString * const CLWebItemDeletedAtKey  = @"CLWebItemDeletedAtKey";


@implementation CLWebItem

@synthesize name = _name, type = _type, contentURL = _contentURL, mimeType = _mimeType,
            viewCount = _viewCount, remoteURL = _remoteURL,  href = _href, URL = _URL, iconURL = _iconURL,
            icon = _icon, trashed = _trashed, private = _private, createdAt = _createdAt,
            updatedAt = _updatedAt, deletedAt = _deletedAt;

- (id)init
{
	return [self initWithName:nil];
}

- (id)initWithName:(NSString *)theName
{
	return [self initWithName:theName type:CLWebItemTypeNone viewCount:0];
}

- (id)initWithName:(NSString *)theName type:(CLWebItemType)theType viewCount:(NSInteger)theCount
{
	if ((self = [super init])) {
		_name      = [theName copy];
		_type      = theType;
		_viewCount = theCount;
	}
	return self;
}

+ (id)webItem
{
	return [[[[self class] alloc] init] autorelease];
}

+ (id)webItemWithName:(NSString *)theName
{
	return [[[[self class] alloc] initWithName:theName] autorelease];
}

+ (id)webItemWithName:(NSString *)theName type:(CLWebItemType)theType viewCount:(NSInteger)theCount
{
	return [[[[self class] alloc] initWithName:theName type:theType viewCount:theCount] autorelease];
}

- (NSString *)description
{
    static NSString *format = @"<%@: %@ (%i) %@>";
	return [NSString stringWithFormat:format, NSStringFromClass([self class]), self.name, self.viewCount, self.URL];
}

#pragma mark -
#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
	CLWebItem *retItem = [[[self class] alloc] initWithName:self.name type:self.type viewCount:self.viewCount];
	retItem.contentURL = self.contentURL;
	retItem.mimeType   = self.mimeType;
	retItem.remoteURL  = self.remoteURL;
	retItem.href       = self.href;
	retItem.trashed    = self.trashed;
	retItem.private    = self.private;
	retItem.iconURL    = self.iconURL;
	retItem.icon       = self.icon;
	retItem.URL        = self.URL;
    
	return retItem;
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init])) {
		if ([decoder allowsKeyedCoding]) {
			_name       = [[decoder decodeObjectForKey:CLWebItemNameKey] retain];
			_type       = [decoder decodeIntegerForKey:CLWebItemTypeKey];
			_viewCount  = [decoder decodeIntegerForKey:CLWebItemViewCountKey];
			_contentURL = [[decoder decodeObjectForKey:CLWebItemContentURLKey] retain];
			_URL        = [[decoder decodeObjectForKey:CLWebItemURLKey] retain];
			_mimeType   = [[decoder decodeObjectForKey:CLWebItemMimeTypeKey] retain];
			_remoteURL  = [[decoder decodeObjectForKey:CLWebItemRemoteURLKey] retain];
			_href       = [[decoder decodeObjectForKey:CLWebItemHrefKey] retain];
			_trashed    = [decoder decodeBoolForKey:CLWebItemTrashedKey];
			_private    = [decoder decodeBoolForKey:CLWebItemPrivateKey];
			_iconURL    = [[decoder decodeObjectForKey:CLWebItemIconURLKey] retain];
			_icon       = [[decoder decodeObjectForKey:CLWebItemIconKey] retain];
			_createdAt  = [[decoder decodeObjectForKey:CLWebItemCreatedAtKey] retain];
			_updatedAt  = [[decoder decodeObjectForKey:CLWebItemUpdatedAtKey] retain];
			_deletedAt  = [[decoder decodeObjectForKey:CLWebItemDeletedAtKey] retain];
		}
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	if ([encoder allowsKeyedCoding]) {
		[encoder encodeObject:self.name forKey:CLWebItemNameKey];
		[encoder encodeInteger:self.type forKey:CLWebItemTypeKey];
		[encoder encodeInteger:self.viewCount forKey:CLWebItemViewCountKey];
		[encoder encodeObject:self.contentURL forKey:CLWebItemContentURLKey];
		[encoder encodeObject:self.URL forKey:CLWebItemURLKey];
		[encoder encodeObject:self.mimeType forKey:CLWebItemMimeTypeKey];
		[encoder encodeObject:self.remoteURL forKey:CLWebItemRemoteURLKey];
		[encoder encodeObject:self.href forKey:CLWebItemHrefKey];
		[encoder encodeBool:self.trashed forKey:CLWebItemTrashedKey];
		[encoder encodeBool:self.private forKey:CLWebItemPrivateKey];
		[encoder encodeObject:self.icon forKey:CLWebItemIconKey];
		[encoder encodeObject:self.iconURL forKey:CLWebItemIconURLKey];
		[encoder encodeObject:self.createdAt forKey:CLWebItemCreatedAtKey];
		[encoder encodeObject:self.updatedAt forKey:CLWebItemUpdatedAtKey];
		[encoder encodeObject:self.deletedAt forKey:CLWebItemDeletedAtKey];
	}
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc
{
    [_name release];
	_name = nil;
    [_contentURL release];
	_contentURL = nil;
    [_mimeType release];
	_mimeType = nil;
    [_remoteURL release];
	_remoteURL = nil;
    [_href release];
	_href = nil;
    [_iconURL release];
	_iconURL = nil;
    [_icon release];
	_icon = nil;
    [_URL release];
	_URL = nil;
    [_createdAt release];
	_createdAt = nil;
    [_updatedAt release];
	_updatedAt = nil;
    [_deletedAt release];
	_deletedAt = nil;
    
	[super dealloc];
}

@end
