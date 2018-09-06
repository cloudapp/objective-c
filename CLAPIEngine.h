//
//  CLAPIEngine.h
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLAPIEngineDelegate.h"
#import "CLAPIEngineConstants.h"
#import "CLWebItem.h"
#import "CLAccount.h"

// Upload options
extern NSString *const CLAPIEngineUploadOptionPrivacyKey; // Value is CLAPIEnginePrivacyOptionPrivate or CLAPIEnginePrivacyOptionPublic

extern NSString *const CLAPIEnginePrivacyOptionPrivate;
extern NSString *const CLAPIEnginePrivacyOptionPublic;

@interface CLAPIEngine : NSObject {
    NSString *_email;
    NSString *_password;
    NSURL *_baseURL;
    id <CLAPIEngineDelegate> __weak _delegate;
    id <CLAPIEngineInternalDelegate> __weak _iternaldelegate;

    NSMutableSet *_transactions;
    
    BOOL _clearsCookies;
}

@property (nonatomic, readwrite, copy) NSString *email;
@property (nonatomic, readwrite, copy) NSString *password;
@property (nonatomic, readwrite, weak) id<CLAPIEngineDelegate> delegate;
@property (nonatomic, readwrite, weak) id<CLAPIEngineInternalDelegate> internaldelegate;

@property (nonatomic, readwrite, strong) NSURL *baseURL;
@property (nonatomic, readwrite, strong) NSMutableSet *transactions;

// This property makes the engine clear the cookies before making a new connection.
// This can be helpful when credentials are "stuck."
@property (nonatomic, readwrite, assign) BOOL clearsCookies;

- (id)initWithDelegate:(id<CLAPIEngineDelegate>)aDelegate;
+ (id)engine;
+ (id)engineWithDelegate:(id<CLAPIEngineDelegate>)aDelegate;
+ (instancetype _Nonnull)shared;
// Returns whether or not the email/password fields are complete.
- (BOOL)isReady;

// Base URL for connections, usually http://my.cl.ly/
+ (NSURL *)defaultBaseURL;

// Cancel the connection with identifier
- (void)cancelConnection:(NSString *)connectionIdentifier;
- (void)cancelConnection:(NSString *)connectionIdentifier success:(BOOL *)success;

// Cancel all connections
- (void)cancelAllConnections;

- (id)userInfoForConnectionIdentifier:(NSString *)identifier;
- (CLAPIRequestType)requestTypeForConnectionIdentifier:(NSString *)identifier;

- (void)createAccountWithEmail:(NSString *)accountEmail password:(NSString *)accountPassword acceptTerms:(BOOL)acceptTerms userInfo:(id)userInfo;
- (void)changeDefaultSecurityOfAccountToUsePrivacy:(BOOL)privacy userInfo:(id)userInfo;

- (void)changePrivacyOfItem:(CLWebItem *)webItem toPrivate:(BOOL)isPrivate userInfo:(id)userInfo;
- (void)changePrivacyOfItemAtHref:(NSURL *)href toPrivate:(BOOL)isPrivate userInfo:(id)userInfo;
- (void)changeNameOfItem:(CLWebItem *)webItem toName:(NSString *)newName userInfo:(id)userInfo;
- (void)changeNameOfItemAtHref:(NSURL *)href toName:(NSString *)newName userInfo:(id)userInfo;
- (void)getAccountInformationWithUserInfo:(id)userInfo;
- (void)getItemInformation:(CLWebItem *)item userInfo:(id)userInfo;
- (void)getItemInformationAtURL:(NSURL *)itemURL userInfo:(id)userInfo;
- (void)bookmarkLinkWithURL:(NSURL *)URL name:(NSString *)name userInfo:(id)userInfo;
- (void)uploadFileWithName:(NSString *)fileName fileData:(NSData *)fileData userInfo:(id)userInfo;
- (void)bookmarkLinkWithURL:(NSURL *)URL name:(NSString *)name options:(NSDictionary *)options userInfo:(id)userInfo;
- (void)uploadFileWithName:(NSString *)fileName fileData:(NSData *)fileData options:(NSDictionary *)options userInfo:(id)userInfo;
- (void)uploadFileWithName:(NSString *)fileName atPathOnDisk:(NSString *)pathOnDisk options:(NSDictionary<NSString*,NSString*>*)options userInfo:(id)userInfo;

- (void)deleteItem:(CLWebItem *)webItem userInfo:(id)userInfo;
- (void)deleteItemAtHref:(NSURL *)href userInfo:(id)userInfo;
- (void)restoreItem:(CLWebItem *)webItem userInfo:(id)userInfo;
- (void)restoreItemAtHref:(NSURL *)href userInfo:(id)userInfo;
- (void)getItemListStartingAtPage:(NSInteger)pageNumStartingAtOne itemsPerPage:(NSInteger)perPage userInfo:(id)userInfo;
- (void)getItemListStartingAtPage:(NSInteger)pageNumStartingAtOne ofType:(CLWebItemType)type itemsPerPage:(NSInteger)perPage userInfo:(id)userInfo;
- (void)getItemListStartingAtPage:(NSInteger)pageNumStartingAtOne ofType:(CLWebItemType)type itemsPerPage:(NSInteger)perPage showOnlyItemsInTrash:(BOOL)showOnlyItemsInTrash userInfo:(id)userInfo;

- (void)getStoreProductsWithUserInfo:(id)userInfo;
- (void)redeemStoreReceipt:(NSString *)base64Receipt userInfo:(id)userInfo;
- (void)getAccountToken:(id)userInfo;
- (void)loadAccountStatisticsWithUserInfo:(id)userInfo;
- (void)getAccountTokenFromGoogleAuth:(NSString*)accessToken and:(id)userInfo;
- (void)getJWTfromToken:(NSString*)accessToken and:(id)userInfo;
- (void)logIn;
- (void)logOut;
@end
