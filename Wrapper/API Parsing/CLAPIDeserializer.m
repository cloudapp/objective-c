//
//  CLAPIDeserializer.m
//  Cloud
//
//  Created by Nick Paulson on 12/29/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import "CLAPIDeserializer.h"
#import "CLWebItem.h"
#import "CLAccount.h"
#import "CJSONDeserializer.h"
#import "NSMutableURLRequest+NPPOSTBody.h"
#import "NSString+NPMimeType.h"

@implementation CLAPIDeserializer

+ (CLAccount *)accountWithJSONDictionaryData:(NSData *)jsonData {
	if ([jsonData length] == 0)
		return nil;
	NSError *jsonError = nil;
	NSDictionary *dict = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&jsonError];
	if (jsonError != nil)
		return nil;
	return [self accountWithAPIDictionary:dict];
}

+ (CLAccount *)accountWithAPIDictionary:(NSDictionary *)accountDict {
	CLAccount *account = [CLAccount accountWithEmail:[accountDict objectForKey:@"email"]];
	NSString *domain = [accountDict objectForKey:@"domain"];
	if (domain != nil && ![domain isEqual:[NSNull null]])
		account.domain = [NSURL URLWithString:domain];
	NSString *homepage = [accountDict objectForKey:@"domain_home_page"];
	if (homepage != nil && ![homepage isEqual:[NSNull null]])
		account.domainHomePage = [NSURL URLWithString:homepage];
	account.uploadsArePrivate = [[accountDict objectForKey:@"private_items"] isEqual:@"true"];
	account.type = [[accountDict objectForKey:@"subscribed"] isEqual:@"true"] ? CLAccountTypePro : CLAccountTypeFree;
	account.alphaUser = [[accountDict objectForKey:@"alpha"] isEqual:@"true"];
	return account;
}

+ (NSArray *)webItemArrayWithJSONArrayData:(NSData *)jsonData {
	if ([jsonData length] == 0)
		return nil;
	NSError *jsonError = nil;
	NSArray *array = [[CJSONDeserializer deserializer] deserializeAsArray:jsonData error:&jsonError];
	if (jsonError != nil)
		return nil;
	return [self webItemArrayWithAPIArray:array];
}

+ (NSArray *)webItemArrayWithAPIArray:(NSArray *)arrayOfAPIDicts {
	NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:[arrayOfAPIDicts count]];
	for (NSDictionary *apiDict in arrayOfAPIDicts) {
		[retArray addObject:[self webItemWithAPIDictionary:apiDict]];
	}
	return [NSArray arrayWithArray:retArray];
}

+ (CLWebItem *)webItemWithJSONDictionaryData:(NSData *)jsonData {
	if ([jsonData length] == 0)
		return nil;
	NSError *jsonError = nil;
	NSDictionary *dict = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&jsonError];
	if (jsonError != nil)
		return nil;
	return [self webItemWithAPIDictionary:dict];
}

+ (CLWebItem *)webItemWithAPIDictionary:(NSDictionary *)jsonDict {
	CLWebItem *webItem = [CLWebItem webItemWithName:[jsonDict objectForKey:@"name"] 
											   type:[[self class] webItemTypeForTypeString:[jsonDict objectForKey:@"item_type"]]
										  viewCount:[[jsonDict objectForKey:@"view_counter"] integerValue]];
	
	webItem.remoteURL = [NSURL URLWithString:[jsonDict objectForKey:([webItem type] == CLWebItemTypeBookmark) ? @"redirect_url" : @"remote_url"]];
	webItem.URL = [NSURL URLWithString:[jsonDict objectForKey:@"url"]];
	webItem.href = [NSURL URLWithString:[jsonDict objectForKey:@"href"]];
	webItem.trashed = ([jsonDict objectForKey:@"deleted_at"] != nil && ![[NSNull null] isEqual:[jsonDict objectForKey:@"deleted_at"]]);
	webItem.iconURL = [NSURL URLWithString:[jsonDict objectForKey:@"icon"]];
	webItem.private = [[jsonDict objectForKey:@"private"] isEqual:@"true"];
	return webItem;
}

+ (CLWebItemType)webItemTypeForTypeString:(NSString *)typeString {
	typeString = [typeString lowercaseString];
	CLWebItemType retType = CLWebItemTypeNone;
	if ([typeString isEqualToString:@"archive"]) {
		retType = CLWebItemTypeArchive;
	} else if ([typeString isEqualToString:@"audio"]) {
		retType = CLWebItemTypeAudio;
	} else if ([typeString isEqualToString:@"video"]) {
		retType = CLWebItemTypeVideo;
	} else if ([typeString isEqualToString:@"text"]) {
		retType = CLWebItemTypeText;
	} else if ([typeString isEqualToString:@"bookmark"]) {
		retType = CLWebItemTypeBookmark;
	} else if ([typeString isEqualToString:@"image"]) {
		retType = CLWebItemTypeImage;
	} else if ([typeString isEqualToString:@"other"]) {
		retType = CLWebItemTypeUnknown;
	}
	return retType;
}

+ (NSURLRequest *)URLRequestWithS3ParametersDictionaryData:(NSData *)jsonData fileName:(NSString *)fileName fileData:(NSData *)fileData {
	if ([jsonData length] == 0)
		return nil;
	NSError *jsonError = nil;
	NSDictionary *dict = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&jsonError];
	if (jsonError != nil)
		return nil;
	return [self URLRequestWithS3ParametersDictionary:dict fileName:fileName fileData:fileData];
}

+ (NSURLRequest *)URLRequestWithS3ParametersDictionary:(NSDictionary *)s3Dict fileName:(NSString *)fileName fileData:(NSData *)fileData {
	NSURL *postURL = [NSURL URLWithString:[s3Dict objectForKey:@"url"]];
	NSDictionary *actualParams = [s3Dict objectForKey:@"params"];
	if ([[postURL absoluteString] length] == 0 || [[actualParams allKeys] count] == 0)
		return nil;
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL];
	[request setHTTPMethod:@"POST"];
	[request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", NPHTTPBoundary] forHTTPHeaderField:@"Content-Type"];
	for (NSString *currKey in [actualParams allKeys]) {
		[request addToHTTPBodyValue:[actualParams objectForKey:currKey] forKey:currKey];
	}
	[request addToHTTPBodyFileData:fileData fileName:fileName mimeType:[fileName mimeType] forKey:@"file"];
	[request finalizeHTTPBody];
	return request;
}

@end
