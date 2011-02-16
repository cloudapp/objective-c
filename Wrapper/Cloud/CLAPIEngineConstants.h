//
//  CLAPIEngineConstants.h
//  Cloud
//
//  Created by Nick Paulson on 12/29/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

enum {
	CLAPIRequestTypeAccountUpdate = 0,
	CLAPIRequestTypeItemUpdate,
	CLAPIRequestTypeItemDeletion,
	CLAPIRequestTypeGetItemList,
	CLAPIRequestTypeLinkBookmark,
	CLAPIRequestTypeCreateAccount,
	CLAPIRequestTypeGetAccountInformation,
	CLAPIRequestTypeGetItemInformation,
	CLAPIRequestTypeGetS3UploadCredentials,
	CLAPIRequestTypeS3FileUpload
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
