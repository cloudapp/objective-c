//
//  CLSocket.h
//  Cloud
//
//  Created by Matthias Plappert on 20.02.11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *const CLSocketItemsChannel;


@interface CLSocket : NSObject {
	NSString *_APIKey;
	NSInteger _appID;
	NSURL *_authURL;
	NSDictionary *_channels;
}

@property (nonatomic, readwrite, copy) NSString *APIKey;
@property (nonatomic, readwrite, assign) NSInteger appID;
@property (nonatomic, readwrite, retain) NSURL *authURL;
@property (nonatomic, readwrite, retain) NSDictionary *channels;

@end
