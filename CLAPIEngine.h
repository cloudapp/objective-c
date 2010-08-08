//
//  CLAPIEngine.h
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLWebItem.h"
#import "CLUpload.h"
#import "CLFileUpload.h"
#import "CLTextUpload.h"
#import "CLRedirectUpload.h"
#import "CLAccount.h"
#import "CLAPIEngineDelegate.h"

@class CLUpload, CLAccount;
@interface CLAPIEngine : NSObject {
	NSString *email;
	NSString *password;
	id<CLAPIEngineDelegate> delegate;
	NSURL *baseURL;
	
	NSMutableDictionary *_connectionDictionary;
	
	BOOL clearsCookies;
	BOOL downloadsIcons;
}

@property (copy, readwrite) NSString *email;
@property (copy, readwrite) NSString *password;
@property (assign, readwrite) id<CLAPIEngineDelegate> delegate;
@property (retain, readwrite) NSURL *baseURL;
@property (assign, readwrite) BOOL clearsCookies;
@property (assign, readwrite) BOOL downloadsIcons;

- (id)initWithDelegate:(id<CLAPIEngineDelegate>)aDelegate;
+ (CLAPIEngine *)engine;
+ (CLAPIEngine *)engineWithDelegate:(id<CLAPIEngineDelegate>)aDelegate;

- (BOOL)isReady;

- (NSString *)getAccountInformation;
- (NSString *)doUpload:(CLUpload *)theUpload;

//Page numbers start at 1
- (NSString *)getRecentItemsStartingAtPage:(NSInteger)thePage count:(NSInteger)theCount;
- (NSString *)getRecentItemsStartingAtPage:(NSInteger)thePage count:(NSInteger)theCount trashedItems:(BOOL)returnTrashedItems;
- (NSString *)getRecentItemsStartingAtPage:(NSInteger)thePage count:(NSInteger)theCount type:(CLWebItemType)theType trashedItems:(BOOL)returnTrashedItems;
- (NSString *)getInformationForItemAtShortURL:(NSURL *)shortURL;
- (NSString *)updateItem:(CLWebItem *)theItem;
- (NSString *)updateAccount:(CLAccount *)theAccount;
- (NSString *)deleteItem:(CLWebItem *)theItem;
- (NSString *)deleteItemAtHref:(NSURL *)theHref;

@end
