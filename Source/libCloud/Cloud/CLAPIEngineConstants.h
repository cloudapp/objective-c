//
//  CLAPIEngineConstants.h
//  Cloud
//
//  Created by Matthias Plappert on 5/4/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import <Foundation/Foundation.h>


enum {
	CLAPIRequestTypeAccountUpdate = 0,
	CLAPIRequestTypeItemUpdatePrivacy,
    CLAPIRequestTypeItemUpdateName,
	CLAPIRequestTypeItemDeletion,
    CLAPIRequestTypeItemRestoration,
	CLAPIRequestTypeGetItemList,
	CLAPIRequestTypeLinkBookmark,
	CLAPIRequestTypeCreateAccount,
	CLAPIRequestTypeGetAccountInformation,
	CLAPIRequestTypeGetItemInformation,
	CLAPIRequestTypeGetS3UploadCredentials,
	CLAPIRequestTypeS3FileUpload,
    CLAPIRequestTypeGetStoreProducts,
    CLAPIRequestTypeStoreReceiptRedemption
};
typedef NSInteger CLAPIRequestType;


enum {
	CLWebItemTypeImage = 0,
	CLWebItemTypeBookmark,
	CLWebItemTypeText,
	CLWebItemTypeArchive,
	CLWebItemTypeAudio,
	CLWebItemTypeVideo,
	CLWebItemTypeUnknown,
	CLWebItemTypeNone
};
typedef NSInteger CLWebItemType;


// Error domain and user info keys
extern NSString *const CLAPIEngineErrorDomain;
extern NSString *const CLAPIEngineErrorMessagesKey;
extern NSString *const CLAPIEngineErrorRequestTypeKey;
extern NSString *const CLAPIEngineErrorStatusCodeKey;

// Error codes
enum {
    CLAPIEngineErrorUnknown             = -1,
    CLAPIEngineErrorUploadLimitExceeded =  1,
    CLAPIEngineErrorUploadTooLarge      =  2
};
