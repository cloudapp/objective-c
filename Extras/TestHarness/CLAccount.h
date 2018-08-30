//
//  CLAccount.h
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import <Foundation/Foundation.h>


enum {
	CLAccountTypeFree,
	CLAccountTypePro
};
typedef NSInteger CLAccountType;


@class CLSocket;


@interface CLAccount : NSObject<NSCopying, NSCoding> {
	NSURL *_domain;
	NSURL *_domainHomePage;
	BOOL _alphaUser;
	BOOL _uploadsArePrivate;
	NSString *_email;
    NSDate *_subscriptionExpiresAt;
	CLAccountType _type;
	CLSocket *_socket;
}

@property (nonatomic, readwrite, retain) NSURL *domain;
@property (nonatomic, readwrite, retain) NSURL *domainHomePage;
@property (nonatomic, readwrite, assign, getter = isAlphaUser) BOOL alphaUser;
@property (nonatomic, readwrite, assign) BOOL uploadsArePrivate;
@property (nonatomic, readwrite, copy) NSString *email;
@property (nonatomic, readwrite, retain) NSDate *subscriptionExpiresAt;
@property (nonatomic, readwrite, assign) CLAccountType type;
@property (nonatomic, readwrite, retain) CLSocket *socket;

- (id)initWithEmail:(NSString *)anEmail;
+ (id)accountWithEmail:(NSString *)anEmail;

@end
