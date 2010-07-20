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
	CLWebItemTypeTrash
} CLWebItemType;

@interface CLWebItem : NSObject<NSCopying, NSCoding> {
	NSString *name;
	CLWebItemType type;
	NSURL *contentURL;
	NSString *mimeType;
	NSInteger viewCount;
	NSURL *remoteURL;
	NSURL *href;
	NSImage *icon;
}

@property (copy, readwrite) NSString *name;
@property (assign, readwrite) CLWebItemType type;
@property (copy, readwrite) NSURL *contentURL;
@property (copy, readwrite) NSString *mimeType;
@property (assign, readwrite) NSInteger viewCount;
@property (copy, readwrite) NSURL *remoteURL;
@property (copy, readwrite) NSURL *href;
@property (retain, readwrite) NSImage *icon;

- (id)initWithName:(NSString *)theName type:(CLWebItemType)theType viewCount:(NSInteger)theCount;
+ (CLWebItem *)webItemWithName:(NSString *)theName type:(CLWebItemType)theType viewCount:(NSInteger)theCount;

@end
