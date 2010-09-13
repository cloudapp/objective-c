//
//  CLWebItem.h
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _CLWebItemType {
	CLWebItemTypeImage,
	CLWebItemTypeBookmark,
	CLWebItemTypeText,
	CLWebItemTypeArchive,
	CLWebItemTypeAudio,
	CLWebItemTypeVideo,
	CLWebItemTypeOther,
	CLWebItemTypeNone
} CLWebItemType;

@interface CLWebItem : NSObject<NSCopying, NSCoding> {
	NSString *name;
	CLWebItemType type;
	NSURL *contentURL;
	NSString *mimeType;
	NSInteger viewCount;
	NSURL *remoteURL;
	NSURL *href;
	NSURL *URL;
#if TARGET_OS_IPHONE
	UIImage *icon;
#else
	NSImage *icon;
#endif
	NSURL *iconURL;
	BOOL trashed;
	BOOL private;
}

@property (copy, readwrite) NSString *name;
@property (assign, readwrite) CLWebItemType type;
@property (retain, readwrite) NSURL *contentURL;
@property (retain, readwrite) NSURL *URL;
@property (copy, readwrite) NSString *mimeType;
@property (assign, readwrite) NSInteger viewCount;
@property (retain, readwrite) NSURL *remoteURL;
@property (retain, readwrite) NSURL *href;
#if TARGET_OS_IPHONE
@property (retain, readwrite) UIImage *icon;
#else
@property (retain, readwrite) NSImage *icon;
#endif
@property (retain, readwrite) NSURL *iconURL;
@property (assign, readwrite) BOOL trashed;
@property (assign, readwrite, getter=isPrivate) BOOL private;

- (id)initWithName:(NSString *)theName;
- (id)initWithName:(NSString *)theName type:(CLWebItemType)theType viewCount:(NSInteger)theCount;

+ (CLWebItem *)webItem;
+ (CLWebItem *)webItemWithName:(NSString *)theName;
+ (CLWebItem *)webItemWithName:(NSString *)theName type:(CLWebItemType)theType viewCount:(NSInteger)theCount;

@end
