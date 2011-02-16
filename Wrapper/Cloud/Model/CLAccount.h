//
//  CLAccount.h
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _CLAccountType {
	CLAccountTypeFree,
	CLAccountTypePro
} CLAccountType;

@interface CLAccount : NSObject<NSCopying, NSCoding> {
	NSURL *_domain;
	NSURL *_domainHomePage;
	BOOL _alphaUser;
	BOOL _uploadsArePrivate;
	NSString *_email;
	CLAccountType _type;
}

@property (nonatomic, readwrite, retain) NSURL *domain;
@property (nonatomic, readwrite, retain) NSURL *domainHomePage;
@property (nonatomic, readwrite) BOOL alphaUser;
@property (nonatomic, readwrite, assign) BOOL uploadsArePrivate;
@property (nonatomic, readwrite, copy) NSString *email;
@property (nonatomic, readwrite, assign) CLAccountType type;

- (id)initWithEmail:(NSString *)anEmail;
+ (id)accountWithEmail:(NSString *)anEmail;

@end
