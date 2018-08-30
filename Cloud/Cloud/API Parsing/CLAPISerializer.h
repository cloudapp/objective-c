//
//  CLAPISerializer.h
//  Cloud
//
//  Created by Nick Paulson on 12/29/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLAPIEngineConstants.h"


@interface CLAPISerializer : NSObject {

}

+ (NSString *)webItemTypeStringForType:(CLWebItemType)theType;
+ (NSData *)accountWithEmail:(NSString *)email password:(NSString *)password acceptTerms:(BOOL)acceptTerms;
+ (NSData *)itemWithName:(NSString *)newName;
+ (NSData *)itemWithPrivate:(BOOL)isPrivate;
+ (NSData *)itemForRestore;
+ (NSData *)bookmarkWithURL:(NSURL *)URL name:(NSString *)name;
+ (NSData *)bookmarkWithURL:(NSURL *)URL name:(NSString *)name private:(BOOL)private;
+ (NSData *)receiptWithBase64String:(NSString *)base64String;

+ (NSData *)JSONDataFromDictionary:(NSDictionary *)dict;
+ (NSData *)JSONDataFromArray:(NSArray *)array;

@end
