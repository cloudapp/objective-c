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
    CLAPIRequestTypeItemUpdatePrivacy, //1
    CLAPIRequestTypeItemUpdateName, //2
    CLAPIRequestTypeItemDeletion,   //3
    CLAPIRequestTypeItemRestoration, //4
    CLAPIRequestTypeGetItemList,  //5
    CLAPIRequestTypeLinkBookmark,  //6
    CLAPIRequestTypeCreateAccount, //7
    CLAPIRequestTypeGetAccountInformation,  //8
    CLAPIRequestTypeGetItemInformation,  //9
    CLAPIRequestTypeGetS3UploadCredentials, //10
    CLAPIRequestTypeS3FileUpload, //11
    CLAPIRequestTypeS3FileUploadStreamingUpload, //12
    CLAPIRequestTypeS3FileUploadStreamingUploadFinalisation,
    CLAPIRequestTypeGetStoreProducts,
    CLAPIRequestTypeStoreReceiptRedemption,
    CLAPIRequestTypeAccountStatisticsRetrieval,
    CLAPIRequestTypeAccountToken,
    
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
    CLWebItemTypeNone,
    CLWebItemTypeTrash
};
typedef NSInteger CLWebItemType;


// Error domain and user info keys
extern NSString *const CLAPIEngineErrorDomain;
extern NSString *const CLAPIEngineErrorMessagesKey;
extern NSString *const CLAPIEngineErrorRequestTypeKey;
extern NSString *const CLAPIEngineErrorStatusCodeKey;

extern NSString *const CLAPIEngineErrorInfoFilesizeInformationKey;
//extern NSString *const CLAPIEngineErrorInfoUploadsRemainingInformationKey;

// Error codes
enum {
    CLAPIEngineErrorUnknown             = -1,
    CLAPIEngineErrorUploadLimitExceeded =  1,
    CLAPIEngineErrorUploadTooLarge      =  2
};
