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
static NSString * const CLWebItemMimeTypeKey = @"CLWebItemMimeTypeKey";
static NSString * const CLWebItemViewCountKey = @"CLWebItemViewCountKey";
static NSString * const CLWebItemRemoteURLKey = @"CLWebItemRemoteURLKey";
static NSString * const CLWebItemHrefKey = @"CLWebItemHrefKey";
static NSString * const CLWebItemIconKey = @"CLWebItemIconKey";

@implementation CLWebItem
@synthesize name, type, contentURL, mimeType, viewCount, remoteURL, href, icon;

- (id)init {
	return [self initWithName:nil type:CLWebItemTypeOther viewCount:0];
}

- (id)initWithName:(NSString *)theName type:(CLWebItemType)theType viewCount:(NSInteger)theCount {
	if (self = [super init]) {
		self.name = theName;
		self.type = theType;
		self.viewCount = theCount;
	}
	return self;
}

+ (CLWebItem *)webItemWithName:(NSString *)theName type:(CLWebItemType)theType viewCount:(NSInteger)theCount {
	return [[[[self class] alloc] initWithName:theName type:theType viewCount:theCount] autorelease];
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
			mimeType = [decoder decodeObjectForKey:CLWebItemMimeTypeKey];
			remoteURL = [decoder decodeObjectForKey:CLWebItemRemoteURLKey];
			href = [decoder decodeObjectForKey:CLWebItemHrefKey];
			icon = [decoder decodeObjectForKey:CLWebItemIconKey];
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
		[encoder encodeObject:self.mimeType forKey:CLWebItemMimeTypeKey];
		[encoder encodeObject:self.remoteURL forKey:CLWebItemRemoteURLKey];
		[encoder encodeObject:self.href forKey:CLWebItemHrefKey];
		[encoder encodeObject:self.icon forKey:CLWebItemIconKey];
	}
}


@end
