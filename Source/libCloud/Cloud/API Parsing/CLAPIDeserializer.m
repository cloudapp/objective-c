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
#import "CLSocket.h"
#import "JSON.h"
#import "NSMutableURLRequest+NPPOSTBody.h"
#import "NSString+NPMimeType.h"
#import "NSURL+IFUnicodeURL.h"


@interface CLAPIDeserializer (Private)

+ (id)_normalizedObjectFromDictionary:(NSDictionary *)dict forKey:(NSString *)key; // NSNull -> nil
+ (NSDate *)_dateAndTimeFromDictionary:(NSDictionary *)dict forKey:(NSString *)key;
+ (NSDate *)_dateFromDictionary:(NSDictionary *)dict forKey:(NSString *)key;
+ (NSURL *)_URLFromDictionary:(NSDictionary *)dict forKey:(NSString *)key;
+ (NSURL *)_unicodeURLFromDictionary:(NSDictionary *)dict forKey:(NSString *)key;

@end


@implementation CLAPIDeserializer

+ (CLAccount *)accountWithJSONDictionaryData:(NSData *)jsonData
{
	NSDictionary *dict = [self dictionaryFromJSONData:jsonData];
	if (dict == nil)
		return nil;
    
	return [self accountWithAPIDictionary:dict];
}

+ (CLAccount *)accountWithAPIDictionary:(NSDictionary *)accountDict
{
	CLAccount *account            = [CLAccount accountWithEmail:[self _normalizedObjectFromDictionary:accountDict forKey:@"email"]];
	account.domain                = [self _unicodeURLFromDictionary:accountDict forKey:@"domain"];
	account.domainHomePage        = [self _unicodeURLFromDictionary:accountDict forKey:@"domain_home_page"];
	account.uploadsArePrivate     = [[self _normalizedObjectFromDictionary:accountDict forKey:@"private_items"] boolValue];
	account.type                  = [[self _normalizedObjectFromDictionary:accountDict forKey:@"subscribed"] boolValue] ? CLAccountTypePro : CLAccountTypeFree;
    account.subscriptionExpiresAt = [self _dateFromDictionary:accountDict forKey:@"subscription_expires_at"];
	account.alphaUser             = [[self _normalizedObjectFromDictionary:accountDict forKey:@"alpha"] boolValue];
	
	// Socket
	NSDictionary *socketDict = [self _normalizedObjectFromDictionary:accountDict forKey:@"socket"];
	account.socket = [self socketWithJSONDictionary:socketDict];
	
	return account;
}

+ (CLSocket *)socketWithJSONDictionaryData:(NSData *)jsonData
{
	NSDictionary *dict = [self dictionaryFromJSONData:jsonData];
	if (dict == nil)
		return nil;
    
	return [self socketWithJSONDictionary:dict];
}

+ (CLSocket *)socketWithJSONDictionary:(NSDictionary *)jsonDict
{
	if (jsonDict == nil) {
		return nil;
	}
	
	CLSocket *socket = [[[CLSocket alloc] init] autorelease];
	socket.APIKey    = [self _normalizedObjectFromDictionary:jsonDict forKey:@"api_key"];
	socket.appID     = [[self _normalizedObjectFromDictionary:jsonDict forKey:@"app_id"] intValue];
	socket.authURL   = [self _URLFromDictionary:jsonDict forKey:@"auth_url"];
	
	// Channels
	NSDictionary *channels = [self _normalizedObjectFromDictionary:jsonDict forKey:@"channels"];
	if (channels != nil && [channels isKindOfClass:[NSDictionary class]]) {
		socket.channels = channels;
	} else {
		socket.channels = nil;
	}
	
	return socket;
}

+ (NSArray *)webItemArrayWithJSONArrayData:(NSData *)jsonData
{
	NSArray *array = [self arrayFromJSONData:jsonData];
	if (array == nil)
		return nil;
    
	return [self webItemArrayWithAPIArray:array];
}

+ (NSArray *)webItemArrayWithAPIArray:(NSArray *)arrayOfAPIDicts
{
	NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:[arrayOfAPIDicts count]];
	for (NSDictionary *apiDict in arrayOfAPIDicts) {
		[retArray addObject:[self webItemWithAPIDictionary:apiDict]];
	}
    
	return [NSArray arrayWithArray:retArray];
}

+ (CLWebItem *)webItemWithJSONDictionaryData:(NSData *)jsonData
{
	NSDictionary *dict = [self dictionaryFromJSONData:jsonData];
	if (dict == nil)
		return nil;
    
	return [self webItemWithAPIDictionary:dict];
}

+ (CLWebItem *)webItemWithAPIDictionary:(NSDictionary *)jsonDict
{
    CLWebItem *webItem = [CLWebItem webItem];
    
    webItem.name      = [self _normalizedObjectFromDictionary:jsonDict forKey:@"name"];
    webItem.type      = [self webItemTypeForTypeString:[self _normalizedObjectFromDictionary:jsonDict forKey:@"item_type"]];
    webItem.viewCount = [[self _normalizedObjectFromDictionary:jsonDict forKey:@"view_counter"] integerValue];
	
	if (webItem.type == CLWebItemTypeBookmark) {
		webItem.remoteURL = [self _unicodeURLFromDictionary:jsonDict forKey:@"redirect_url"];
		if (webItem.name == nil) {
            // Use the remote URL if the item has no name
			webItem.name = [webItem.remoteURL unicodeAbsoluteString];
        }
	} else {
		webItem.remoteURL = [self _URLFromDictionary:jsonDict forKey:@"remote_url"];
	}
	
	webItem.URL       = [self _unicodeURLFromDictionary:jsonDict forKey:@"url"];
	webItem.href      = [self _URLFromDictionary:jsonDict forKey:@"href"];
	webItem.iconURL   = [self _URLFromDictionary:jsonDict forKey:@"icon"];
	webItem.thumbURL  = [self _URLFromDictionary:jsonDict forKey:@"thumbnail_url"];
	webItem.private   = [[self _normalizedObjectFromDictionary:jsonDict forKey:@"private"] boolValue];
	webItem.createdAt = [self _dateAndTimeFromDictionary:jsonDict forKey:@"created_at"];
	webItem.updatedAt = [self _dateAndTimeFromDictionary:jsonDict forKey:@"updated_at"];
	webItem.deletedAt = [self _dateAndTimeFromDictionary:jsonDict forKey:@"deleted_at"];
	webItem.trashed   = webItem.deletedAt == nil ? NO : YES;
	
	return webItem;
}

+ (CLWebItemType)webItemTypeForTypeString:(NSString *)typeString
{
	typeString = [typeString lowercaseString];
	CLWebItemType retType = CLWebItemTypeUnknown;
    
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
	}
	
	return retType;
}

+ (NSURLRequest *)URLRequestWithS3ParametersDictionaryData:(NSData *)jsonData fileName:(NSString *)fileName fileData:(NSData *)fileData
{
	NSDictionary *dict = [self dictionaryFromJSONData:jsonData];
	if (dict == nil)
		return nil;
    
	return [self URLRequestWithS3ParametersDictionary:dict fileName:fileName fileData:fileData];
}

+ (NSURLRequest *)URLRequestWithS3ParametersDictionary:(NSDictionary *)s3Dict fileName:(NSString *)fileName fileData:(NSData *)fileData
{
    // Make sure to combine any decomposed pieces of any unicode characters (may be diacritical marks) into precomposed characters
    fileName = [fileName precomposedStringWithCanonicalMapping];
    
	NSURL *postURL             = [self _URLFromDictionary:s3Dict forKey:@"url"];
	NSDictionary *actualParams = [self _normalizedObjectFromDictionary:s3Dict forKey:@"params"];
	if ([[postURL absoluteString] length] == 0 || [[actualParams allKeys] count] == 0)
		return nil;
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL];
	[request setHTTPMethod:@"POST"];
	[request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@; charset=UTF-8", NPHTTPBoundary] forHTTPHeaderField:@"Content-Type"];
    
	for (NSString *currKey in [actualParams allKeys]) {
		[request addToHTTPBodyValue:[actualParams objectForKey:currKey] forKey:currKey];
	}
    
	[request addToHTTPBodyFileData:fileData fileName:fileName mimeType:[fileName mimeType] forKey:@"file"];
	[request finalizeHTTPBody];
    
	return request;
}

+ (NSArray *)productsWithJSONArrayData:(NSData *)jsonData
{
    NSArray *array = [self arrayFromJSONData:jsonData];
    return array;
}

#pragma mark -
#pragma mark General

+ (NSDictionary *)dictionaryFromJSONData:(NSData *)data
{
	if (data == nil || [data length] == 0)
		return nil;
	
	NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	id object = [jsonString JSONValue];
	[jsonString release];
	
	if (object == nil || ![object isKindOfClass:[NSDictionary class]])
		return nil;
    
	return object;
}

+ (NSArray *)arrayFromJSONData:(NSData *)data
{
	if (data == nil || [data length] == 0)
		return nil;
	
	NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	id object = [jsonString JSONValue];
	[jsonString release];
	
	if (object == nil || ![object isKindOfClass:[NSArray class]])
		return nil;
    
	return object;
}

#pragma mark -
#pragma mark Private

+ (id)_normalizedObjectFromDictionary:(NSDictionary *)dict forKey:(NSString *)key
{
	id object = [dict objectForKey:key];
	if (object == [NSNull null])
		return nil;
    
	return object;
}

+ (NSDate *)_dateAndTimeFromDictionary:(NSDictionary *)dict forKey:(NSString *)key
{
	// Date parsing
	static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		
		// Set locale to US to avoid formatting issues
		NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"US"];
		[dateFormatter setLocale:locale];
		[locale release];
		
		[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]]; // GMT timezone
		[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"]; // example: 2010-06-21T12:51:06Z
	}
	
	NSString *dateString = [dict objectForKey:key];
	if (dateString == nil || ![dateString isKindOfClass:[NSString class]]) {
		// Invalid date
		return nil;
	}
	
	return [dateFormatter dateFromString:dateString];
}

+ (NSDate *)_dateFromDictionary:(NSDictionary *)dict forKey:(NSString *)key
{
    // Date parsing
	static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		
		// Set locale to US to avoid formatting issues
		NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"US"];
		[dateFormatter setLocale:locale];
		[locale release];
		
		[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]]; // GMT timezone
		[dateFormatter setDateFormat:@"yyyy-MM-dd"]; // example: 2010-06-21T12:51:06Z
	}
	
	NSString *dateString = [dict objectForKey:key];
	if (dateString == nil || ![dateString isKindOfClass:[NSString class]]) {
		// Invalid date
		return nil;
	}
	
	return [dateFormatter dateFromString:dateString];
}

+ (NSURL *)_URLFromDictionary:(NSDictionary *)dict forKey:(NSString *)key
{
	NSString *string = [dict objectForKey:key];
	if (string == nil || ![string isKindOfClass:[NSString class]])
		return nil;
    
	return [NSURL URLWithString:string];
}

+ (NSURL *)_unicodeURLFromDictionary:(NSDictionary *)dict forKey:(NSString *)key
{
	NSString *string = [dict objectForKey:key];
	if (string == nil || ![string isKindOfClass:[NSString class]])
		return nil;
    
	return [NSURL URLWithUnicodeString:string];
}

@end
