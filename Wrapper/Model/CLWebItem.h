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
#ifdef TARGET_OS_MAC
	NSImage *_icon;
#else
	UIImage *_icon;
#endif
	BOOL _trashed;
	BOOL _private;
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
#ifdef TARGET_OS_MAC
@property (nonatomic, readwrite, copy) NSImage *icon;
#else
@property (nonatomic, readwrite, copy) UIImage *icon;
#endif
@property (nonatomic, readwrite, assign) BOOL trashed;
@property (nonatomic, readwrite, assign, getter=isPrivate) BOOL private;

- (id)initWithName:(NSString *)theName;
- (id)initWithName:(NSString *)theName type:(CLWebItemType)theType viewCount:(NSInteger)theCount;

+ (id)webItem;
+ (id)webItemWithName:(NSString *)theName;
+ (id)webItemWithName:(NSString *)theName type:(CLWebItemType)theType viewCount:(NSInteger)theCount;

@end
