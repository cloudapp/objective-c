//
//  CLAPIEngine.h
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLWebItem.h"

@class CLUpload, CLAccount;
@interface CLAPIEngine : NSObject {
	NSString *email;
	NSString *password;
	BOOL notificationsEnabled;
	BOOL clearsCookies;
}

@property (copy, readwrite) NSString *email;
@property (copy, readwrite) NSString *password;
@property (assign, readwrite) BOOL notificationsEnabled;
@property (assign, readwrite) BOOL clearsCookies;

- (NSString *)getAccountInformation;
- (NSString *)doUpload:(CLUpload *)theUpload;
- (NSString *)getRecentItemsStartingAtPage:(NSInteger)thePage count:(NSInteger)theCount;
- (NSString *)getRecentItemsStartingAtPage:(NSInteger)thePage count:(NSInteger)theCount trashedItems:(BOOL)returnTrashedItems;
- (NSString *)getRecentItemsStartingAtPage:(NSInteger)thePage count:(NSInteger)theCount type:(CLWebItemType)theType trashedItem:(BOOL)returnTrashedItems;
- (NSString *)getInformationForItemAtShortURL:(NSURL *)shortURL;
- (NSString *)updateItem;
- (NSString *)updateAccount;
- (NSString *)updateAccount:(CLAccount *)theAccount;
- (NSString *)deleteItem:(CLWebItem *)theItem;

@end
