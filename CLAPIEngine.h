//
//  CLAPIEngine.h
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLWebItem.h"

@protocol CLAPIEngineDelegate <NSObject>
@optional
//- 
@end

@class CLUpload, CLAccount;
@interface CLAPIEngine : NSObject {
	NSString *email;
	NSString *password;
}

@property (copy, readwrite) NSString *email;
@property (copy, readwrite) NSString *password;

- (NSString *)getAccountInformation;
- (NSString *)doUpload:(CLUpload *)theUpload;
- (NSString *)getRecentItemsStartingAtPage:(NSInteger)thePage count:(NSInteger)theCount;
- (NSString *)getRecentItemsStartingAtPage:(NSInteger)thePage count:(NSInteger)theCount trashedItems:(BOOL)returnTrashedItems;
- (NSString *)getRecentItemsStartingAtPage:(NSInteger)thePage count:(NSInteger)theCount type:(CLWebItemType)theType trashedItem:(BOOL)returnTrashedItems;
- (NSString *)getInformationForItemAtShortURL:(NSURL *)shortURL;
- (NSString *)updateItem:(CLWebItem *)theItem;
- (NSString *)updateAccount:(CLAccount *)theAccount;
- (NSString *)deleteItem:(CLWebItem *)theItem;

@end
