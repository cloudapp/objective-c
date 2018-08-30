//
//  CLAPITransaction.m
//  Cloud
//
//  Created by Nick Paulson on 12/29/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import "CLAPITransaction.h"


@implementation CLAPITransaction

@synthesize request = _request, connection = _connection, receivedData = _receivedData,
requestType = _requestType,  userInfo = _userInfo, identifier = _identifier,
response = _response, internalContext = _internalContext, numberOfTries = _numberOfTries;

+ (id)transaction {
    CLAPITransaction *transaction = [[[self class] alloc] init];
    
    if (transaction) {
        transaction.numberOfTries = 1;
    }
    
    return transaction;
}

- (id)init {
    if ((self = [super init])) {
        _receivedData = [[NSMutableData alloc] init];
    }
    
    return self;
}

@end
