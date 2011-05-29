//
//  CLWebItem.h
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLAPIEngineConstants.h"


@interface CLWebItem : NSObject<NSCopying, NSCoding> {
	NSString *_name;
	CLWebItemType _type;
	NSURL *_contentURL;
	NSString *_mimeType;
	NSInteger _viewCount;
	NSURL *_remoteURL;
	NSURL *_href;
	NSURL *_URL;
	NSURL *_iconURL;
#if TARGET_OS_IPHONE
	UIImage *_icon;
#else
	NSImage *_icon;
#endif
	BOOL _trashed;
	BOOL _private;
	NSDate *_createdAt;
	NSDate *_updatedAt;
	NSDate *_deletedAt;
}

@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, assign) CLWebItemType type;
@property (nonatomic, readwrite, retain) NSURL *contentURL;
@property (nonatomic, readwrite, retain) NSURL *URL;
@property (nonatomic, readwrite, copy) NSString *mimeType;
@property (nonatomic, readwrite, assign) NSInteger viewCount;
@property (nonatomic, readwrite, retain) NSURL *remoteURL;
@property (nonatomic, readwrite, retain) NSURL *href;
@property (nonatomic, readwrite, retain) NSURL *iconURL;
#if TARGET_OS_IPHONE
@property (nonatomic, readwrite, copy) UIImage *icon;
#else
@property (nonatomic, readwrite, copy) NSImage *icon;
#endif
@property (nonatomic, readwrite, assign, getter = isTrashed) BOOL trashed;
@property (nonatomic, readwrite, assign, getter = isPrivate) BOOL private;
@property (nonatomic, readwrite, retain) NSDate *createdAt;
@property (nonatomic, readwrite, retain) NSDate *updatedAt;
@property (nonatomic, readwrite, retain) NSDate *deletedAt;

- (id)initWithName:(NSString *)theName;
- (id)initWithName:(NSString *)theName type:(CLWebItemType)theType viewCount:(NSInteger)theCount;

+ (id)webItem;
+ (id)webItemWithName:(NSString *)theName;
+ (id)webItemWithName:(NSString *)theName type:(CLWebItemType)theType viewCount:(NSInteger)theCount;

@end
