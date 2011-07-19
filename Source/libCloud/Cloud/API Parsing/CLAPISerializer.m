//
//  CLAPISerializer.m
//  Cloud
//
//  Created by Nick Paulson on 12/29/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import "CLAPISerializer.h"
#import "JSON.h"


@implementation CLAPISerializer

+ (NSString *)webItemTypeStringForType:(CLWebItemType)theType
{
	NSString *retString = nil;
	switch (theType) {
		case CLWebItemTypeArchive:
			retString = @"archive";
			break;
		case CLWebItemTypeAudio:
			retString = @"audio";
			break;
		case CLWebItemTypeVideo:
			retString = @"video";
			break;
		case CLWebItemTypeText:
			retString = @"text";
			break;
		case CLWebItemTypeBookmark:
			retString = @"bookmark";
			break;
		case CLWebItemTypeImage:
			retString = @"image";
			break;
		case CLWebItemTypeUnknown:
		default:
			retString = @"unknown";
			break;
	}
	return retString;
}

+ (NSData *)accountWithEmail:(NSString *)email password:(NSString *)password acceptTerms:(BOOL)acceptTerms
{
	if (email == nil || password == nil)
		return nil;
	
    NSNumber *acceptTermsObj = [NSNumber numberWithBool:acceptTerms];
    NSDictionary *user = [NSDictionary dictionaryWithObjectsAndKeys:email, @"email",
                                                                    password, @"password",
                                                                    acceptTermsObj, @"accept_tos", nil];
	NSDictionary *dict = [NSDictionary dictionaryWithObject:user forKey:@"user"];
    
	return [self JSONDataFromDictionary:dict];
}

+ (NSData *)itemWithName:(NSString *)newName
{
	if (newName == nil)
		return nil;
	
    NSDictionary *item = [NSDictionary dictionaryWithObject:newName forKey:@"name"];
	NSDictionary *dict = [NSDictionary dictionaryWithObject:item forKey:@"item"];
    
	return [self JSONDataFromDictionary:dict];
}

+ (NSData *)itemWithPrivate:(BOOL)isPrivate
{
    NSDictionary *item = [NSDictionary dictionaryWithObject:isPrivate ? @"true" : @"false" forKey:@"private"];
	NSDictionary *dict = [NSDictionary dictionaryWithObject:item forKey:@"item"];
    
	return [self JSONDataFromDictionary:dict];
}

+ (NSData *)itemForRestore
{
    NSDictionary *item = [NSDictionary dictionaryWithObject:[NSNull null] forKey:@"deleted_at"];
    NSDictionary *container = [NSDictionary dictionaryWithObjectsAndKeys:item, @"item",
                                                                         [NSNumber numberWithBool:YES], @"deleted", nil];
    return [self JSONDataFromDictionary:container];
}

+ (NSData *)bookmarkWithURL:(NSURL *)URL name:(NSString *)name
{
	if (URL == nil || name == nil)
		return nil;
	
    NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:[URL absoluteString], @"redirect_url",
                                                                    name, @"name", nil];
	NSDictionary *dict = [NSDictionary dictionaryWithObject:item forKey:@"item"];
	return [self JSONDataFromDictionary:dict];
}

+ (NSData *)bookmarkWithURL:(NSURL *)URL name:(NSString *)name private:(BOOL)private
{
	if (URL == nil || name == nil)
		return nil;
	
    NSString *privateString = private ? @"true" : @"false";
    NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:[URL absoluteString], @"redirect_url",
                          name, @"name", privateString, @"private", nil];
	NSDictionary *dict = [NSDictionary dictionaryWithObject:item forKey:@"item"];
	return [self JSONDataFromDictionary:dict];
}

+ (NSData *)receiptWithBase64String:(NSString *)base64String
{
    NSDictionary *receipt = [NSDictionary dictionaryWithObject:base64String
                                                        forKey:@"receipt-data"];
    return [self JSONDataFromDictionary:receipt];
}

#pragma mark -
#pragma mark General

+ (NSData *)JSONDataFromDictionary:(NSDictionary *)dict
{
	if (dict == nil || ![dict isKindOfClass:[NSDictionary class]])
		return nil;
	
	NSString *jsonString = [dict JSONRepresentation];
	if (jsonString == nil)
		return nil;
    
	return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSData *)JSONDataFromArray:(NSArray *)array
{
	if (array == nil || ![array isKindOfClass:[NSArray class]])
		return nil;
	
	NSString *jsonString = [array JSONRepresentation];
	if (jsonString == nil)
		return nil;
    
	return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
}

@end
