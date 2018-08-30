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
            response = _response, internalContext = _internalContext;

+ (id)transaction
{
	return [[[self class] alloc] init];
}

- (id)init
{
	if ((self = [super init])) {
		_receivedData = [[NSMutableData alloc] init];
	}
	return self;
}

- (void)dealloc
{
    _request = nil;
	_response = nil;
    _connection = nil;
    _receivedData = nil;
    _userInfo = nil;
	_identifier = nil;
	_internalContext = nil;
	
}

@end
