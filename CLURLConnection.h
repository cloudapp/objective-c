//
//  CLURLConnection.h
//  Cloud
//
//  Created by Nick Paulson on 7/25/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _CLURLRequestType {
	CLURLRequestTypeAccountInformation,
	CLURLRequestTypeUpload,
	CLURLRequestTypeS3Upload,
	CLURLRequestTypeRecentItems,
	CLURLRequestTypeShortURLInformation,
	CLURLRequestTypeUpdateItem,
	CLURLRequestTypeUpdateAccount,
	CLURLRequestTypeDeleteItem,
	CLURLRequestTypeUnknown
} CLURLRequestType;

@interface CLURLConnection : NSURLConnection {
	NSMutableData *data;
	CLURLRequestType requestType;
	NSString *identifier;
	id userInfo;
	NSDate *startDate;
	NSHTTPURLResponse *response;
}

@property (retain, readwrite) NSMutableData *data;
@property (copy, readwrite) NSString *identifier;
@property (assign, readwrite) CLURLRequestType requestType;
@property (retain, readwrite) id userInfo;
@property (retain, readonly) NSDate *startDate;
@property (retain, readwrite) NSHTTPURLResponse *response;

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate requestType:(CLURLRequestType)reqType identifier:(NSString *)anID;
- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate requestType:(CLURLRequestType)reqType identifier:(NSString *)anID startImmediately:(BOOL)startImmediately;

@end
