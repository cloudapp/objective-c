//
//  CLAPIDeserializer.h
//  Cloud
//
//  Created by Nick Paulson on 12/29/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLAPIEngineConstants.h"

@class CLWebItem, CLAccount;
@interface CLAPIDeserializer : NSObject {

}

+ (NSArray *)webItemArrayWithJSONArrayData:(NSData *)jsonData;
+ (NSArray *)webItemArrayWithAPIArray:(NSArray *)arrayOfAPIDicts;
+ (CLWebItem *)webItemWithJSONDictionaryData:(NSData *)jsonData;
+ (CLWebItem *)webItemWithAPIDictionary:(NSDictionary *)jsonDict;
+ (CLAccount *)accountWithJSONDictionaryData:(NSData *)jsonData;
+ (CLAccount *)accountWithAPIDictionary:(NSDictionary *)accountDict;
+ (CLWebItemType)webItemTypeForTypeString:(NSString *)typeString;
+ (NSURLRequest *)URLRequestWithS3ParametersDictionaryData:(NSData *)jsonData fileName:(NSString *)fileName fileData:(NSData *)fileData;
+ (NSURLRequest *)URLRequestWithS3ParametersDictionary:(NSDictionary *)s3Dict fileName:(NSString *)fileName fileData:(NSData *)fileData;

@end
