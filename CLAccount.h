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
	NSInteger uploadCountLimit;
	NSUInteger uploadBytesLimit;
	BOOL uploadsArePrivate;
	NSString *emailAddress;
	CLAccountType type;
}

@property (assign, readwrite) NSInteger uploadCountLimit;
@property (assign, readwrite) NSUInteger uploadBytesLimit;
@property (assign, readwrite) BOOL uploadsArePrivate;
@property (copy, readwrite) NSString *emailAddress;
@property (assign, readwrite) CLAccountType type;

- (id)initWithEmailAddress:(NSString *)anEmail;
+ (CLAccount *)accountWithEmailAddress:(NSString *)anEmail;

@end
