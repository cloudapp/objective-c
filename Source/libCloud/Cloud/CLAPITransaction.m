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
	return [[[[self class] alloc] init] autorelease];
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
    [_request release];
    _request = nil;
    [_response release];
	_response = nil;
    [_connection release];
    _connection = nil;
    [_receivedData release];
    _receivedData = nil;
    [_userInfo release];
    _userInfo = nil;
    [_identifier release];
	_identifier = nil;
    [_internalContext release];
	_internalContext = nil;
	
    [super dealloc];
}

@end
