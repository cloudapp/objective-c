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

+ (NSString *)webItemTypeStringForType:(CLWebItemType)theType {
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
			retString = @"other";
			break;
	}
	return retString;
}

+ (NSData *)accountWithEmail:(NSString *)email password:(NSString *)password {
	if (email == nil || password == nil)
		return nil;
	
	NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObjectsAndKeys:email, @"email", password, @"password", nil]
													 forKey:@"user"];
	return [self JSONDataFromDictionary:dict];
}

+ (NSData *)itemWithName:(NSString *)newName {
	if (newName == nil)
		return nil;
	
	NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:newName forKey:@"name"]
													 forKey:@"item"];
	return [self JSONDataFromDictionary:dict];
}

+ (NSData *)itemWithPrivate:(BOOL)isPrivate {
	NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:isPrivate ? @"true" : @"false" forKey:@"private"]
													 forKey:@"item"];
	return [self JSONDataFromDictionary:dict];
}

+ (NSData *)bookmarkWithURL:(NSURL *)URL name:(NSString *)name {
	if (URL == nil || name == nil)
		return nil;
	
	NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObjectsAndKeys:name, @"name", [URL absoluteString], @"redirect_url", nil]
													 forKey:@"item"];
	return [self JSONDataFromDictionary:dict];
}

#pragma mark -
#pragma mark General

+ (NSData *)JSONDataFromDictionary:(NSDictionary *)dict {
	if (dict == nil || ![dict isKindOfClass:[NSDictionary class]])
		return nil;
	
	NSString *jsonString = [dict JSONRepresentation];
	if (jsonString == nil)
		return nil;
	return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSData *)JSONDataFromArray:(NSArray *)array {
	if (array == nil || ![array isKindOfClass:[NSArray class]])
		return nil;
	
	NSString *jsonString = [array JSONRepresentation];
	if (jsonString == nil)
		return nil;
	return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
}

@end
