//
//  CLAPIEngine.m
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import "CLAPIEngine.h"
#import "CLUpload.h"
#import "CLURLConnection.h"
#import "NSString+NPAdditions.h"
#import "NSDictionary+BSJSONAdditions.h"
#import "NSArray+BSJSONAdditions.h"
#import "CLAccount.h"
#import "CLFileUpload.h"
#import "ASIFormDataRequest.h"

@interface CLAPIEngine ()
- (CLWebItemType)_webItemTypeForTypeString:(NSString *)typeString;
- (CLWebItem *)_webItemForDictionary:(NSDictionary *)itemDictionary;
- (NSString *)_typeStringForWebItemType:(CLWebItemType)theType;
- (NSString *)_handleRequest:(ASIHTTPRequest *)theRequest type:(CLURLRequestType)reqType userInfo:(id)userInfo;
@end

CGFloat CLUploadLimitExceeded = 301;
CGFloat CLUploadSizeLimitExceeded = 302;

@implementation CLAPIEngine
@synthesize email, password, delegate, baseURL, clearsCookies, downloadsIcons;

- (id)init {
	return [self initWithDelegate:nil];
}

- (id)initWithDelegate:(id<CLAPIEngineDelegate>)aDelegate {
	if (self = [super init]) {
		self.delegate = aDelegate;
		_connectionDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
		self.baseURL = [NSURL URLWithString:@"http://my.cl.ly/"];
		self.clearsCookies = NO;
		self.downloadsIcons = YES;
	}
	return self;
}

+ (CLAPIEngine *)engine {
	return [[[[self class] alloc] init] autorelease];
}

+ (CLAPIEngine *)engineWithDelegate:(id<CLAPIEngineDelegate>)aDelegate {
	return [[[[self class] alloc] initWithDelegate:aDelegate] autorelease];
}

- (NSString *)getAccountInformation {
	ASIHTTPRequest *theRequest = [ASIHTTPRequest requestWithURL:[self.baseURL URLByAppendingPathComponent:@"account"]];
	return [self _handleRequest:theRequest type:CLURLRequestTypeAccountInformation userInfo:nil];
}

- (NSString *)doUpload:(CLUpload *)theUpload {
	if ([theUpload isValid]) {
		ASIHTTPRequest *theRequest = [theUpload requestForURL:self.baseURL];
		return [self _handleRequest:theRequest type:CLURLRequestTypeUpload userInfo:theUpload];
	}
	return nil;
}

- (NSString *)getRecentItemsStartingAtPage:(NSInteger)thePage count:(NSInteger)theCount {
	return [self getRecentItemsStartingAtPage:thePage count:theCount trashedItems:NO];
}

- (NSString *)getRecentItemsStartingAtPage:(NSInteger)thePage count:(NSInteger)theCount trashedItems:(BOOL)returnTrashedItems {
	return [self getRecentItemsStartingAtPage:thePage count:theCount type:CLWebItemTypeNone trashedItems:returnTrashedItems];
}

- (NSString *)getRecentItemsStartingAtPage:(NSInteger)thePage count:(NSInteger)theCount type:(CLWebItemType)theType trashedItems:(BOOL)returnTrashedItems {
	thePage = MAX(1, thePage);
	theCount = MAX(0, theCount);
	NSMutableString *urlAppend = [NSMutableString stringWithFormat:@"items?page=%i&per_page=%i", thePage, theCount];
	if (theType != CLWebItemTypeNone)
		[urlAppend appendFormat:@"&type=%@", [self _typeStringForWebItemType:theType]];
	if (returnTrashedItems)
		[urlAppend appendString:@"&deleted=true"];
	
	//If the URL path component method is used, it turns ? into %3F and causes the request to fail
	ASIHTTPRequest *theRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[[self.baseURL absoluteString] stringByAppendingString:urlAppend]]];
	return [self _handleRequest:theRequest type:CLURLRequestTypeRecentItems userInfo:nil];
}

- (NSString *)getInformationForItemAtShortURL:(NSURL *)shortURL {
	ASIHTTPRequest *theRequest = [ASIHTTPRequest requestWithURL:shortURL];
	return [self _handleRequest:theRequest type:CLURLRequestTypeShortURLInformation userInfo:shortURL];
}

- (NSString *)updateItem:(CLWebItem *)theItem {
	ASIFormDataRequest *theRequest = [ASIFormDataRequest requestWithURL:[theItem href]];
	[theRequest setRequestMethod:@"PUT"];
	[theRequest addPostValue:[theItem isPrivate] ? @"true" : @"false" forKey:@"item[private]"];
	[theRequest addPostValue:[theItem name] forKey:@"item[name]"];
	return [self _handleRequest:theRequest type:CLURLRequestTypeUpdateItem userInfo:theItem];
}

- (NSString *)updateAccount:(CLAccount *)theAccount {
	ASIFormDataRequest *theRequest = [ASIFormDataRequest requestWithURL:[self.baseURL URLByAppendingPathComponent:@"account"]];
	[theRequest setRequestMethod:@"PUT"];
	[theRequest addPostValue:([theAccount uploadsArePrivate] ? @"true" : @"false") forKey:@"user[private_items]"];
	return [self _handleRequest:theRequest type:CLURLRequestTypeUpdateAccount userInfo:theAccount];
}

- (NSString *)deleteItem:(CLWebItem *)theItem {
	return [self deleteItemAtHref:[theItem href]];
}

- (NSString *)deleteItemAtHref:(NSURL *)theHref {
	ASIFormDataRequest *theRequest = [ASIFormDataRequest requestWithURL:theHref];
	[theRequest setRequestMethod:@"DELETE"];
	return [self _handleRequest:theRequest type:CLURLRequestTypeDeleteItem userInfo:theHref];
}

- (BOOL)isReady {
	return self.email != nil && [self.email length] > 0 && self.password != nil && [self.password length] > 0 && self.baseURL != nil && [[self.baseURL absoluteString] length] > 0;
}

- (void)cancelConnection:(NSString *)connectionIdentifier {
	if (![[_connectionDictionary allKeys] containsObject:connectionIdentifier])
		return;
	CLURLConnection *theConnection = [_connectionDictionary objectForKey:connectionIdentifier];
	if (theConnection == nil)
		return;
	[theConnection cancel];
	[_connectionDictionary removeObjectForKey:connectionIdentifier];
}

#pragma mark NSURLConnection Delegate Methods

- (void)requestStarted:(ASIHTTPRequest *)request {
	NSString *identifier = [[request userInfo] objectForKey:@"identifier"];
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(requestStarted:)])
		[self.delegate requestStarted:identifier];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	if ([request responseStatusCode] == 404) {
		[request failWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:[NSDictionary dictionaryWithObject:@"File not found" forKey:NSLocalizedDescriptionKey]]];
		return;
	}
	NSInteger requestType = [[[request userInfo] objectForKey:@"requestType"] integerValue];
	NSString *retString = [request responseString];
	NSString *identifier = [[request userInfo] objectForKey:@"identifier"];
	id userInfo = [[request userInfo] objectForKey:@"userInfo"];
	switch (requestType) {
		case CLURLRequestTypeUpload: {
			CLUpload *theUpload = (CLUpload *)userInfo;
			if ([theUpload usesS3]) {
				NSDictionary *s3Dict = [NSDictionary dictionaryWithJSONString:retString];
				if (s3Dict == nil) {
					[request failWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:[NSDictionary dictionaryWithObject:@"No parameter dictionary" forKey:NSLocalizedDescriptionKey]]];
					return;
				}
				
				if ([[s3Dict allKeys] containsObject:@"uploads_remaining"] && [[s3Dict objectForKey:@"uploads_remaining"] integerValue] <= 0) {
					[request failWithError:[NSError errorWithDomain:NSURLErrorDomain code:CLUploadLimitExceeded userInfo:[NSDictionary dictionaryWithObject:@"Upload limit exceeded" forKey:NSLocalizedDescriptionKey]]];
					return;
				}
				
				if ([[s3Dict allKeys] containsObject:@"max_upload_size"] && [theUpload size] > [[s3Dict objectForKey:@"max_upload_size"] integerValue]) {
					[request failWithError:[NSError errorWithDomain:NSURLErrorDomain code:CLUploadSizeLimitExceeded userInfo:[NSDictionary dictionaryWithObject:@"Max upload size exceeded" forKey:NSLocalizedDescriptionKey]]];
					return;
				}
				
				NSURL *s3URL = [NSURL URLWithString:[s3Dict objectForKey:@"url"]];
				if (s3URL == nil) {
					[request failWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:[NSDictionary dictionaryWithObject:@"No S3 URL found" forKey:NSLocalizedDescriptionKey]]];
					return;
				}
				NSDictionary *paramsDict = [s3Dict objectForKey:@"params"];
				if (paramsDict == nil) {
					[request failWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:[NSDictionary dictionaryWithObject:@"No parameter keys found" forKey:NSLocalizedDescriptionKey]]];
					return;
				}
				ASIHTTPRequest *s3Request = [theUpload s3RequestForURL:s3URL parameterDictionary:paramsDict];
				[self _handleRequest:s3Request type:CLURLRequestTypeS3Upload userInfo:theUpload];
			} else {
			case CLURLRequestTypeS3Upload: {
				NSDictionary *itemDictionary = [NSDictionary dictionaryWithJSONString:retString];
				if (itemDictionary == nil) {
					[request failWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:[NSDictionary dictionaryWithObject:@"Server returned invalid item information" forKey:NSLocalizedDescriptionKey]]];
					return;
				}
				CLWebItem *theItem = [self _webItemForDictionary:itemDictionary];
				if (self.delegate != nil && [self.delegate respondsToSelector:@selector(uploadSucceeded:resultingItem:forRequest:)])
					[self.delegate uploadSucceeded:userInfo resultingItem:theItem forRequest:identifier];
			}
			}
		}
			break;
		case CLURLRequestTypeRecentItems: {
			NSArray *dictArray = [NSArray arrayWithJSONString:retString];
			NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:[dictArray count]];
			for (NSDictionary *currDict in dictArray) {
				[itemArray addObject:[self _webItemForDictionary:currDict]];
			}
			if (self.delegate != nil && [self.delegate respondsToSelector:@selector(recentItemsReceived:forRequest:)])
				[self.delegate recentItemsReceived:itemArray forRequest:identifier];
		}
			break;
		case CLURLRequestTypeDeleteItem: {
			if (self.delegate != nil && [self.delegate respondsToSelector:@selector(hrefDeleted:forRequest:)])
				[self.delegate hrefDeleted:userInfo forRequest:identifier];
		}
			break;
		case CLURLRequestTypeAccountInformation: {
			
		}
			break;
		case CLURLRequestTypeShortURLInformation: {
			NSDictionary *itemDictionary = [NSDictionary dictionaryWithJSONString:retString];
			if (itemDictionary == nil) {
				[request failWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:[NSDictionary dictionaryWithObject:@"Server returned invalid item information" forKey:NSLocalizedDescriptionKey]]];
				return;
			}
			CLWebItem *theItem = [self _webItemForDictionary:itemDictionary];
			if (self.delegate != nil && [self.delegate respondsToSelector:@selector(shortURLInformationReceived:forRequest:)])
				[self.delegate shortURLInformationReceived:theItem forRequest:identifier];
		}
			break;
		case CLURLRequestTypeUpdateAccount: {
			
		}
			break;
		case CLURLRequestTypeUpdateItem: {
			
		}
			break;
		case CLURLRequestTypeUnknown:
		default:
			break;
	}
	
	if ([[_connectionDictionary allKeys] containsObject:identifier])
		[_connectionDictionary removeObjectForKey:identifier];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	NSError *error = [request error];
	NSString *identifier = [[request userInfo] objectForKey:@"identifier"];
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(requestFailed:withError:)])
		[self.delegate requestFailed:identifier withError:error];
	if ([[_connectionDictionary allKeys] containsObject:identifier])
		[_connectionDictionary removeObjectForKey:identifier];
}

- (void)authenticationNeededForRequest:(ASIHTTPRequest *)request {
	if ([request authenticationRetryCount] == 0) {
		[request applyCredentials:[NSDictionary dictionaryWithObjectsAndKeys:[self.email lowercaseString], kCFHTTPAuthenticationUsername, self.password, kCFHTTPAuthenticationPassword, nil]];
		[request retryUsingSuppliedCredentials];
	} else {
		[request cancelAuthentication];
	}
}

#pragma mark -
#pragma mark Private Methods

- (CLWebItem *)_webItemForDictionary:(NSDictionary *)itemDictionary {
	CLWebItem *theItem = [CLWebItem webItemWithName:[itemDictionary objectForKey:@"name"] 
											   type:[self _webItemTypeForTypeString:[itemDictionary objectForKey:@"item_type"]]
										  viewCount:[[itemDictionary objectForKey:@"view_counter"] integerValue]];
	[theItem setRemoteURL:[NSURL URLWithString:[itemDictionary objectForKey:([theItem type] == CLWebItemTypeBookmark) ? @"redirect_url" : @"remote_url"]]];
	[theItem setURL:[NSURL URLWithString:[itemDictionary objectForKey:@"url"]]];
	[theItem setHref:[NSURL URLWithString:[itemDictionary objectForKey:@"href"]]];
	[theItem setTrashed:([itemDictionary objectForKey:@"deleted_at"] != nil && ![[NSNull null] isEqual:[itemDictionary objectForKey:@"deleted_at"]])];
	[theItem setIconURL:[NSURL URLWithString:[itemDictionary objectForKey:@"icon"]]];
	[theItem setPrivate:[[itemDictionary objectForKey:@"private"] isEqual:@"true"]];
	return theItem;
}

- (CLWebItemType)_webItemTypeForTypeString:(NSString *)typeString {
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
		retType = CLWebItemTypeOther;
	}
	return retType;
}

- (NSString *)_typeStringForWebItemType:(CLWebItemType)theType {
	switch (theType) {
		case CLWebItemTypeArchive:
			return @"archive";
		case CLWebItemTypeAudio:
			return @"audio";
		case CLWebItemTypeVideo:
			return @"video";
		case CLWebItemTypeText:
			return @"text";
		case CLWebItemTypeBookmark:
			return @"bookmark";
		case CLWebItemTypeImage:
			return @"image";
		case CLWebItemTypeOther:
		default:
			return @"other";
	}
	return nil;
}

- (NSString *)_handleRequest:(ASIHTTPRequest *)theRequest type:(CLURLRequestType)reqType userInfo:(id)userInfo {
	if (![self isReady])
		return nil;
	if (self.clearsCookies) {
		NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:self.baseURL];
		for (NSHTTPCookie *currCookie in cookies)
			[[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:currCookie];
	}
	
	if (userInfo == nil)
		userInfo = [NSNull null];
	
	[theRequest setUseSessionPersistence:!self.clearsCookies];
	NSString *identifier = [NSString uniqueString];
	//Thsi dispatch part is to make sure the connection is created and started in the main thread.
	//dispatch_async(dispatch_get_main_queue(), ^{
	[theRequest setUseKeychainPersistence:NO];
	[theRequest addRequestHeader:@"Accept" value:@"application/json"];
	[theRequest setDelegate:self];
	[theRequest setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:userInfo, @"userInfo", [NSNumber numberWithInteger:reqType], @"requestType", identifier, @"identifier", nil]];
	[_connectionDictionary setObject:theRequest forKey:identifier];
	[theRequest startAsynchronous];
	//});
	return identifier;
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc {
	self.email = nil;
	self.password = nil;
	self.delegate = nil;
	[_connectionDictionary release];
	_connectionDictionary = nil;
	[super dealloc];
}

@end
