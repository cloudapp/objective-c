//
//  CLWebItem.m
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import "CLWebItem.h"

static NSString * const CLWebItemNameKey = @"CLWebItemNameKey";
static NSString * const CLWebItemTypeKey = @"CLWebItemTypeKey";
static NSString * const CLWebItemContentURLKey = @"CLWebItemContentURLKey";
static NSString * const CLWebItemURLKey = @"CLWebItemURLKey";
static NSString * const CLWebItemMimeTypeKey = @"CLWebItemMimeTypeKey";
static NSString * const CLWebItemViewCountKey = @"CLWebItemViewCountKey";
static NSString * const CLWebItemRemoteURLKey = @"CLWebItemRemoteURLKey";
static NSString * const CLWebItemHrefKey = @"CLWebItemHrefKey";
static NSString * const CLWebItemIconKey = @"CLWebItemIconKey";
static NSString * const CLWebItemIconURLKey = @"CLWebItemIconURLKey";
static NSString * const CLWebItemTrashedKey = @"CLWebItemTrashedKey";
static NSString * const CLWebItemPrivateKey = @"CLWebItemPrivateKey";

@implementation CLWebItem
@synthesize name, type, contentURL, mimeType, viewCount, remoteURL, href, icon, trashed, private, iconURL, URL;

- (id)init {
	return [self initWithName:nil];
}

- (id)initWithName:(NSString *)theName {
	return [self initWithName:theName type:CLWebItemTypeNone viewCount:0];
}

- (id)initWithName:(NSString *)theName type:(CLWebItemType)theType viewCount:(NSInteger)theCount {
	if (self = [super init]) {
		self.name = theName;
		self.type = theType;
		self.viewCount = theCount;
	}
	return self;
}

+ (CLWebItem *)webItem {
	return [[[[self class] alloc] init] autorelease];
}

+ (CLWebItem *)webItemWithName:(NSString *)theName {
	return [[[[self class] alloc] initWithName:theName] autorelease];
}

+ (CLWebItem *)webItemWithName:(NSString *)theName type:(CLWebItemType)theType viewCount:(NSInteger)theCount {
	return [[[[self class] alloc] initWithName:theName type:theType viewCount:theCount] autorelease];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@ (%i) <%@>", self.name, self.viewCount, self.URL];
}

#pragma mark -
#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
	CLWebItem *retItem = [[[self class] alloc] initWithName:self.name type:self.type viewCount:self.viewCount];
	retItem.contentURL = self.contentURL;
	retItem.mimeType = self.mimeType;
	retItem.remoteURL = self.remoteURL;
	retItem.href = self.href;
	retItem.icon = self.icon;
	retItem.trashed = self.trashed;
	retItem.private = self.private;
	retItem.iconURL = self.iconURL;
	retItem.URL = self.URL;
	return retItem;
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		if ([decoder allowsKeyedCoding]) {
			name = [decoder decodeObjectForKey:CLWebItemNameKey];
			type = [decoder decodeIntegerForKey:CLWebItemTypeKey];
			viewCount = [decoder decodeIntegerForKey:CLWebItemViewCountKey];
			contentURL = [decoder decodeObjectForKey:CLWebItemContentURLKey];
			URL = [decoder decodeObjectForKey:CLWebItemURLKey];
			mimeType = [decoder decodeObjectForKey:CLWebItemMimeTypeKey];
			remoteURL = [decoder decodeObjectForKey:CLWebItemRemoteURLKey];
			href = [decoder decodeObjectForKey:CLWebItemHrefKey];
			icon = [decoder decodeObjectForKey:CLWebItemIconKey];
			trashed = [decoder decodeBoolForKey:CLWebItemTrashedKey];
			private = [decoder decodeBoolForKey:CLWebItemPrivateKey];
			iconURL = [decoder decodeObjectForKey:CLWebItemIconURLKey];
		}
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	if ([encoder allowsKeyedCoding]) {
		[encoder encodeObject:self.name forKey:CLWebItemNameKey];
		[encoder encodeInteger:self.type forKey:CLWebItemTypeKey];
		[encoder encodeInteger:self.viewCount forKey:CLWebItemViewCountKey];
		[encoder encodeObject:self.contentURL forKey:CLWebItemContentURLKey];
		[encoder encodeObject:self.URL forKey:CLWebItemURLKey];
		[encoder encodeObject:self.mimeType forKey:CLWebItemMimeTypeKey];
		[encoder encodeObject:self.remoteURL forKey:CLWebItemRemoteURLKey];
		[encoder encodeObject:self.href forKey:CLWebItemHrefKey];
		[encoder encodeObject:self.icon forKey:CLWebItemIconKey];
		[encoder encodeBool:self.trashed forKey:CLWebItemTrashedKey];
		[encoder encodeBool:self.private forKey:CLWebItemPrivateKey];
		[encoder encodeObject:self.iconURL forKey:CLWebItemIconURLKey];
	}
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc {
	self.name = nil;
	self.contentURL = nil;
	self.mimeType = nil;
	self.remoteURL = nil;
	self.href = nil;
	self.icon = nil;
	self.iconURL = nil;
	self.URL = nil;
	[super dealloc];
}


@end
