//
//  CLAPITransaction.m
//  Cloud
//
//  Created by Nick Paulson on 12/29/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import "CLAPITransaction.h"


@implementation CLAPITransaction

@synthesize request = _request, connection = _connection, receivedData = _receivedData, requestType = _requestType, 
			userInfo = _userInfo, identifier = _identifier, response = _response, internalContext = _internalContext;

- (id)init {
	if ((self = [super init])) {
		self.receivedData = [NSMutableData data];
	}
	return self;
}

+ (id)transaction {
	return [[[[self class] alloc] init] autorelease];
}

- (void)dealloc {
    self.request = nil;
	self.response = nil;
    self.connection = nil;
    self.receivedData = nil;
    self.userInfo = nil;
	self.identifier = nil;
	self.internalContext = nil;
	
    [super dealloc];
}

@end
