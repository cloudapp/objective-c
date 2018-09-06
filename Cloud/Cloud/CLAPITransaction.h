//
//  CLAPITransaction.h
//  Cloud
//
//  Created by Nick Paulson on 12/29/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLAPIEngineConstants.h"


@interface CLAPITransaction : NSObject {
    NSURLRequest *_request;
    NSURLConnection *_connection;
    NSMutableData *_receivedData;
    NSHTTPURLResponse *_response;
    CLAPIRequestType _requestType;
    NSString *_identifier;
    id _userInfo;
    id _internalContext;
}

@property (nonatomic, readwrite, strong) NSURLRequest *request;
@property (nonatomic, readwrite, strong) NSHTTPURLResponse *response;
@property (nonatomic, readwrite, strong) NSURLConnection *connection;
@property (nonatomic, readwrite, strong) NSMutableData *receivedData;
@property (nonatomic, readwrite, assign) CLAPIRequestType requestType;
@property (nonatomic, readwrite, copy) NSString *identifier;
@property (nonatomic, readwrite, strong) id userInfo;
@property (nonatomic, readwrite, strong) id internalContext;
@property (nonatomic, readwrite, assign) NSInteger numberOfTries;
 
+ (id)transaction;

@end
