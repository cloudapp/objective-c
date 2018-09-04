//
//  CLAPIEngineDelegate.h
//  Cloud
//
//  Created by Nick Paulson on 8/8/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class CLWebItem, CLAPITransaction, CLAccount;


@protocol CLAPIEngineDelegate <NSObject>


@optional
- (void)requestDidSucceedWithConnectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo;
- (void)requestDidFailWithError:(NSError *)error connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo;
- (void)requestDidRetryAfterFailureWithError:(NSError *)error connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo;

- (void)fileUploadDidProgress:(CGFloat)percentageComplete connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo;
- (void)fileUploadDidSucceedWithResultingItem:(CLWebItem *)item connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo;

- (void)linkBookmarkDidSucceedWithResultingItem:(CLWebItem *)item connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo;

- (void)accountUpdateDidSucceed:(CLAccount *)account connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo;

- (void)itemUpdateDidSucceed:(CLWebItem *)item connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo;
- (void)itemDeletionDidSucceed:(CLWebItem *)item connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo;
- (void)itemRestorationDidSucceed:(CLWebItem *)item connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo;

- (void)itemInformationRetrievalSucceeded:(CLWebItem *)item connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo;
- (void)accountInformationRetrievalSucceeded:(CLAccount *)account connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo;
- (void)itemListRetrievalSucceeded:(NSArray<CLWebItem *> *)items connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo;
- (void)accountStatisticsRetrievalSucceeded:(NSDictionary *)statistics connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo;

- (void)accountCreationSucceeded:(CLAccount *)newAccount connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo;

- (void)storeProductInformationRetrievalSucceeded:(NSArray *)productIdentifiers connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo;
- (void)storeReceiptRedemptionSucceeded:(CLAccount *)account connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo;
- (void)tokenWith:(NSString *)tokenString and:(NSString *)connectionIdentifier;
@end

@protocol CLAPIEngineInternalDelegate <NSObject>

@optional
- (void)tokenWith:(NSString *)tokenString and:(NSString *)connectionIdentifier;
@end
