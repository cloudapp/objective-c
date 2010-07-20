//
//  CLAccount.h
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import <Foundation/Foundation.h>

enum CLAccountType {
	CLAccountTypeFree,
	CLAccountTypePro
};

@interface CLAccount : NSObject<NSCopying, NSCoding> {
	NSInteger uploadCountLimit;
	NSUInteger uploadBytesLimit;
	BOOL uploadsArePrivate;
	NSString *emailAddress;
	NSString *password;
}

@property (assign, readwrite) NSInteger uploadCountLimit;
@property (assign, readwrite) NSUInteger uploadBytesLimit;
@property (assign, readwrite) BOOL uploadsArePrivate;
@property (copy, readwrite) NSString *emailAddress;
@property (copy, readwrite) NSString *password;

- (id)initWithEmailAddress:(NSString *)anEmail;
+ (CLAccount *)accountWithEmailAddress:(NSString *)anEmail;

@end
