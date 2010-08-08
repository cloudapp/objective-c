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
#import "NSMutableURLRequest+NPPOSTBody.h"
#import "NSDictionary+BSJSONAdditions.h"
#import "NSArray+BSJSONAdditions.h"
#import "CLAccount.h"
#import "CLFileUpload.h"

@interface CLAPIEngine ()
- (CLWebItemType)_webItemTypeForTypeString:(NSString *)typeString;
- (CLWebItem *)_webItemForDictionary:(NSDictionary *)itemDictionary;
- (NSString *)_typeStringForWebItemType:(CLWebItemType)theType;
- (NSString *)_handleRequest:(NSURLRequest *)theRequest type:(CLURLRequestType)reqType userInfo:(id)userInfo;
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
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[self.baseURL URLByAppendingPathComponent:@"account"]];
	[theRequest setHTTPMethod:@"GET"];
	[theRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
	return [self _handleRequest:theRequest type:CLURLRequestTypeAccountInformation userInfo:nil];
}

- (NSString *)doUpload:(CLUpload *)theUpload {
	if ([theUpload isValid]) {
		NSURLRequest *theRequest = [theUpload requestForURL:self.baseURL];
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
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[self.baseURL absoluteString] stringByAppendingPathComponent:urlAppend]]];
	[theRequest setHTTPMethod:@"GET"];
	[theRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
	return [self _handleRequest:theRequest type:CLURLRequestTypeRecentItems userInfo:nil];
}

- (NSString *)getInformationForItemAtShortURL:(NSURL *)shortURL {
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:shortURL];
	[theRequest setHTTPMethod:@"GET"];
	[theRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
	return [self _handleRequest:theRequest type:CLURLRequestTypeShortURLInformation userInfo:shortURL];
}

- (NSString *)updateItem:(CLWebItem *)theItem {
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[theItem href]];
	[theRequest setHTTPMethod:@"PUT"];
	[theRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[theRequest addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", NPHTTPBoundary] forHTTPHeaderField:@"Content-Type"];
	[theRequest addToHTTPBodyValue:[theItem isPrivate] ? @"true" : @"false"  forKey:@"item[private]"];
	[theRequest addToHTTPBodyValue:[theItem name] forKey:@"item[name]"];
	[theRequest finalizeHTTPBody];
	return [self _handleRequest:theRequest type:CLURLRequestTypeUpdateItem userInfo:theItem];
}

- (NSString *)updateAccount:(CLAccount *)theAccount {
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[self.baseURL URLByAppendingPathComponent:@"account"]];
	[theRequest setHTTPMethod:@"PUT"];
	[theRequest addToHTTPBodyValue:([theAccount uploadsArePrivate] ? @"true" : @"false") forKey:@"user[private_items]"];
	[theRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[theRequest finalizeHTTPBody];
	[theRequest addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", NPHTTPBoundary] forHTTPHeaderField:@"Content-Type"];
	
	return [self _handleRequest:theRequest type:CLURLRequestTypeUpdateAccount userInfo:theAccount];
}

- (NSString *)deleteItem:(CLWebItem *)theItem {
	return [self deleteItemAtHref:[theItem href]];
}

- (NSString *)deleteItemAtHref:(NSURL *)theHref {
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theHref];
	[theRequest setHTTPMethod:@"DELETE"];
	[theRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
	return [self _handleRequest:theRequest type:CLURLRequestTypeDeleteItem userInfo:theHref];
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(CLURLConnection *)connection didReceiveData:(NSData *)data {
	[[connection data] appendData:data];
}

- (void)connection:(CLURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	if ([challenge previousFailureCount] == 0) {
		NSURLCredential *credential = [NSURLCredential credentialWithUser:self.email password:self.password persistence:NSURLCredentialPersistenceNone];
		[[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
	} else {
		[[challenge sender] cancelAuthenticationChallenge:challenge];
	}
}

- (void)connection:(CLURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
	if ([connection.userInfo isKindOfClass:[CLUpload class]]) {
		CGFloat percentDone = (CGFloat)totalBytesWritten / (CGFloat)totalBytesExpectedToWrite;
		if (self.delegate != nil && [self.delegate respondsToSelector:@selector(requestProgressed:toPercentage:)])
			[self.delegate requestProgressed:connection.identifier toPercentage:[NSNumber numberWithFloat:percentDone]];
	}
	
	//	NSTimeInterval timeTaken = [[NSDate date] timeIntervalSinceReferenceDate] - [[connection startDate] timeIntervalSinceReferenceDate];
	//	if (percentDone >= 0.20) {
	//		NSTimeInterval totalTime = timeTaken / ((CGFloat)totalBytesWritten / (CGFloat)totalBytesExpectedToWrite);
	//		NSTimeInterval timeLeft = totalTime - timeTaken;
	//		NSLog(@"left = %i", (NSInteger)ceilf(timeLeft));
	//	}
}

- (void)connection:(CLURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
	if ([response isKindOfClass:[NSHTTPURLResponse class]])
		[connection setResponse:response];
}

- (void)connection:(CLURLConnection *)connection didFailWithError:(NSError *)error {
	if ([error code] == NSURLErrorUserCancelledAuthentication)
		error = [NSError errorWithDomain:[error domain] code:[error code] userInfo:[NSDictionary dictionaryWithObject:@"Login failed" forKey:NSLocalizedDescriptionKey]];
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(requestFailed:withError:)])
		[self.delegate requestFailed:connection.identifier withError:error];
}

- (void)connectionDidFinishLoading:(CLURLConnection *)connection {
	if ([[connection response] statusCode] == 404) {
		[self connection:connection didFailWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:[NSDictionary dictionaryWithObject:@"File not found" forKey:NSLocalizedDescriptionKey]]];
		return;
	}
	
	NSString *retString = [NSString stringWithData:[connection data] encoding:NSUTF8StringEncoding];
	switch (connection.requestType) {
		case CLURLRequestTypeUpload: {
			CLUpload *theUpload = connection.userInfo;
			if ([theUpload usesS3]) {
				NSDictionary *s3Dict = [NSDictionary dictionaryWithJSONString:retString];
				if (s3Dict == nil) {
					[self connection:connection didFailWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:[NSDictionary dictionaryWithObject:@"No parameter dictionary" forKey:NSLocalizedDescriptionKey]]];
					return;
				}
				
				if ([[s3Dict allKeys] containsObject:@"uploads_remaining"] && [[s3Dict objectForKey:@"uploads_remaining"] integerValue] <= 0) {
					[self connection:connection didFailWithError:[NSError errorWithDomain:NSURLErrorDomain code:CLUploadLimitExceeded userInfo:[NSDictionary dictionaryWithObject:@"Upload limit exceeded" forKey:NSLocalizedDescriptionKey]]];
					return;
				}
				
				if ([[s3Dict allKeys] containsObject:@"max_upload_size"] && [theUpload size] > [[s3Dict objectForKey:@"max_upload_size"] integerValue]) {
					[self connection:connection didFailWithError:[NSError errorWithDomain:NSURLErrorDomain code:CLUploadSizeLimitExceeded userInfo:[NSDictionary dictionaryWithObject:@"Max upload size exceeded" forKey:NSLocalizedDescriptionKey]]];
					return;
				}
				
				NSURL *s3URL = [NSURL URLWithString:[s3Dict objectForKey:@"url"]];
				if (s3URL == nil) {
					[self connection:connection didFailWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:[NSDictionary dictionaryWithObject:@"No S3 URL found" forKey:NSLocalizedDescriptionKey]]];
					return;
				}
				NSDictionary *paramsDict = [s3Dict objectForKey:@"params"];
				if (paramsDict == nil) {
					[self connection:connection didFailWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:[NSDictionary dictionaryWithObject:@"No parameter keys found" forKey:NSLocalizedDescriptionKey]]];
					return;
				}
				NSMutableURLRequest *s3Request = [theUpload s3RequestForURL:s3URL parameterDictionary:paramsDict];
				[self _handleRequest:s3Request type:CLURLRequestTypeS3Upload userInfo:theUpload];
			} else {
			case CLURLRequestTypeS3Upload: {
				NSDictionary *itemDictionary = [NSDictionary dictionaryWithJSONString:retString];
				if (itemDictionary == nil) {
					[self connection:connection didFailWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:[NSDictionary dictionaryWithObject:@"Server returned invalid item information" forKey:NSLocalizedDescriptionKey]]];
					return;
				}
				CLWebItem *theItem = [self _webItemForDictionary:itemDictionary];
				if (self.delegate != nil && [self.delegate respondsToSelector:@selector(uploadSucceeded:resultingItem:forRequest:)])
					[self.delegate uploadSucceeded:connection.userInfo resultingItem:theItem forRequest:connection.identifier];
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
				[self.delegate recentItemsReceived:itemArray forRequest:connection.identifier];
		}
			break;
		case CLURLRequestTypeDeleteItem: {
			if (self.delegate != nil && [self.delegate respondsToSelector:@selector(hrefDeleted:forRequest:)])
				[self.delegate hrefDeleted:connection.userInfo forRequest:connection.identifier];
		}
			break;
		case CLURLRequestTypeAccountInformation: {
			
		}
			break;
		case CLURLRequestTypeShortURLInformation: {
			NSDictionary *itemDictionary = [NSDictionary dictionaryWithJSONString:retString];
			if (itemDictionary == nil) {
				[self connection:connection didFailWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:[NSDictionary dictionaryWithObject:@"Server returned invalid item information" forKey:NSLocalizedDescriptionKey]]];
				return;
			}
			CLWebItem *theItem = [self _webItemForDictionary:itemDictionary];
			if (self.delegate != nil && [self.delegate respondsToSelector:@selector(shortURLInformationReceived:forRequest:)])
				[self.delegate shortURLInformationReceived:theItem forRequest:connection.identifier];
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
		case CLWebItemTypeOther:
		default:
			retString = @"other";
			break;
	}
	return retString;
}

- (NSString *)_handleRequest:(NSURLRequest *)theRequest type:(CLURLRequestType)reqType userInfo:(id)userInfo {
	if (self.clearsCookies) {
		NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:self.baseURL];
		for (NSHTTPCookie *currCookie in cookies)
			[[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:currCookie];
	}
	NSString *identifier = [NSString uniqueString];
	CLURLConnection *theConnection = [[CLURLConnection alloc] initWithRequest:theRequest delegate:self requestType:reqType identifier:identifier];
	[theConnection setUserInfo:userInfo];
	[_connectionDictionary setObject:theConnection forKey:identifier];
#if TARGET_OS_IPHONE
	[theConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:UITrackingRunLoopMode];
#else
	[theConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSEventTrackingRunLoopMode];
#endif
	[theConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[theConnection autorelease];
	[theConnection start];
	return identifier;
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc {
	self.email = nil;
	self.password = nil;
	self.delegate = nil;
	[_connectionDictionary release];
	[super dealloc];
}

@end
