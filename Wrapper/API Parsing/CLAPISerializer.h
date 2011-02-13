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
+ (NSData *)accountWithEmail:(NSString *)email password:(NSString *)password;
+ (NSData *)itemWithName:(NSString *)newName;
+ (NSData *)itemWithPrivate:(BOOL)isPrivate;
+ (NSData *)bookmarkWithURL:(NSURL *)URL name:(NSString *)name;

+ (NSData *)JSONDataFromDictionary:(NSDictionary *)dict;
+ (NSData *)JSONDataFromArray:(NSArray *)array;

@end
