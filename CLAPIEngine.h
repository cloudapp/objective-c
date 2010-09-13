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
}

@property (copy, readwrite) NSString *email;
@property (copy, readwrite) NSString *password;
@property (assign, readwrite) id<CLAPIEngineDelegate> delegate;
@property (retain, readwrite) NSURL *baseURL;

//This property makes the engine clear the cookies before making a new connection.  
//This can be helpful when credentials are "stuck" with logins.
@property (assign, readwrite) BOOL clearsCookies;

- (id)initWithDelegate:(id<CLAPIEngineDelegate>)aDelegate;
+ (CLAPIEngine *)engine;
+ (CLAPIEngine *)engineWithDelegate:(id<CLAPIEngineDelegate>)aDelegate;

//Returns whether or not the email/password/baseURL fields are complete.
- (BOOL)isReady;

//Cancel the connection with identifier
- (void)cancelConnection:(NSString *)connectionIdentifier;

//Gets account information for the email/password combo that is set.
//This method is currently not full implemented.
- (NSString *)getAccountInformation;

//Upload the object.  The argument is a concrete subclass of CLUpload.
//Current available uploads are CLFileUpload, CLRedirectUpload, and CLTextUpload
- (NSString *)doUpload:(CLUpload *)theUpload;

//Getting the recently uploaded items.  Different filtering options are available.
//Page numbers start at 1.
- (NSString *)getRecentItemsStartingAtPage:(NSInteger)thePage count:(NSInteger)theCount;

//The trashed items flag determines whether or not it should be getting items from the trash or items that are currently alive.
- (NSString *)getRecentItemsStartingAtPage:(NSInteger)thePage count:(NSInteger)theCount trashedItems:(BOOL)returnTrashedItems;
- (NSString *)getRecentItemsStartingAtPage:(NSInteger)thePage count:(NSInteger)theCount type:(CLWebItemType)theType trashedItems:(BOOL)returnTrashedItems;

//Gets the information (metadata included) about a short URL.
//This can be used to get the item type.
- (NSString *)getInformationForItemAtShortURL:(NSURL *)shortURL;

//This makes changes to the item (based upon the href URL).
//This is currently not working.
- (NSString *)updateItem:(CLWebItem *)theItem;

//This makes changes to the account based on the email/password combo.
//This method is going to be changed soon, do not rely on it.
//This method is currently not working.
- (NSString *)updateAccount:(CLAccount *)theAccount;

//Deletes the upload (based on the href URL).
- (NSString *)deleteItem:(CLWebItem *)theItem;

//Deletes the item at the href URL.
- (NSString *)deleteItemAtHref:(NSURL *)theHref;

@end
