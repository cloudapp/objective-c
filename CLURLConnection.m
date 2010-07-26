//
//  CLURLConnection.m
//  Cloud
//
//  Created by Nick Paulson on 7/25/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import "CLURLConnection.h"

@interface CLURLConnection ()
@property (retain, readwrite) NSDate *startDate;
@end

@implementation CLURLConnection
@synthesize requestType, data, identifier, userInfo, startDate;

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate {
	return [self initWithRequest:request delegate:delegate requestType:CLURLRequestTypeUnknown identifier:nil];
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate requestType:(CLURLRequestType)reqType identifier:(NSString *)anID {
	if (self = [super initWithRequest:request delegate:delegate]) {
		self.requestType = reqType;
		self.data = [NSMutableData data];
		self.identifier = anID;
	}
	return self;
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately {
	return [self initWithRequest:request delegate:delegate requestType:CLURLRequestTypeUnknown identifier:nil startImmediately:startImmediately];
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate requestType:(CLURLRequestType)reqType identifier:(NSString *)anID startImmediately:(BOOL)startImmediately {
	if (self = [super initWithRequest:request delegate:delegate startImmediately:startImmediately]) {
		self.requestType = reqType;
		self.data = [NSMutableData data];
		self.identifier = anID;
	}
	return self;
}

- (void)start {
	self.startDate = [NSDate date];
	NSLog(@"self.startdate = %@", self.startDate);
	
	[super start];
}

- (void)dealloc {
	self.data = nil;
	self.identifier = nil;
	[super dealloc];
}

@end
