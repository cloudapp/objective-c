//
//  CLAPIEngine.m
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import "CLAPIEngine.h"
#import "CLWebItem.h"
#import "CLAPITransaction.h"
#import "CJSONSerializer.h"
#import "CJSONDeserializer.h"
#import "CLAPIDeserializer.h"
#import "CLAPISerializer.h"
#import "NSString+NPAdditions.h"

@interface CLAPIEngine ()
- (NSString *)_createAndStartConnectionForTransaction:(CLAPITransaction *)transaction;
- (CLAPITransaction *)_transactionForConnection:(NSURLConnection *)connection;
- (CLAPITransaction *)_transactionForConnectionIdentifier:(NSString *)connectionIdentifier;
@end

static const CGFloat CLUploadLimitExceeded = 301;
static const CGFloat CLUploadSizeLimitExceeded = 302;
static NSString * CLAPIEngineBaseURL = @"http://my.cl.ly";

@implementation CLAPIEngine
@synthesize email = _email, password = _password, delegate = _delegate, clearsCookies = _clearsCookies,
			transactions = _transactions;

+ (void)initialize {
	//This is for testing against another server.
	NSString *possibleURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"CloudAppBaseURL"];
	if ([possibleURL length] > 0)
		CLAPIEngineBaseURL = possibleURL;
}

- (id)init {
	return [self initWithDelegate:nil];
}

- (id)initWithDelegate:(id<CLAPIEngineDelegate>)aDelegate {
	if ((self = [super init])) {
		self.delegate = aDelegate;
		self.transactions = [NSMutableSet set];
		self.clearsCookies = NO;
	}
	return self;
}

+ (id)engine {
	return [[[[self class] alloc] init] autorelease];
}

+ (id)engineWithDelegate:(id<CLAPIEngineDelegate>)aDelegate {
	return [[[[self class] alloc] initWithDelegate:aDelegate] autorelease];
}

- (BOOL)isReady {
	return self.email != nil && [self.email length] > 0 && self.password != nil && [self.password length] > 0;
}

- (NSString *)createAccountWithEmail:(NSString *)accountEmail password:(NSString *)accountPassword userInfo:(id)userInfo {
	if ([accountEmail length] == 0 || [accountPassword length] == 0)
		return nil;
	
	CLAPITransaction *transaction = [CLAPITransaction transaction];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/register", CLAPIEngineBaseURL]]];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
	NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObjectsAndKeys:accountEmail, @"email", accountPassword, @"password", nil] forKey:@"user"];
	
	NSError *jsonError = nil;
	NSData *bodyData = [[CJSONSerializer serializer] serializeDictionary:dict error:&jsonError];
	if (jsonError != nil || bodyData == nil)
		return nil;
	
	[request setHTTPBody:bodyData];
	
	transaction.request = request;
	transaction.identifier = [NSString uniqueString];
	transaction.requestType = CLAPIRequestTypeCreateAccount;
	transaction.userInfo = userInfo;
	
	return [self _createAndStartConnectionForTransaction:transaction];
}

- (NSString *)changeNameOfItem:(CLWebItem *)webItem toName:(NSString *)newName userInfo:(id)userInfo {
	if (![self isReady] || webItem == nil || webItem.href == nil)
		return nil;
	
	CLAPITransaction *transaction = [CLAPITransaction transaction];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:webItem.href];
	[request setHTTPMethod:@"PUT"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
	NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:newName forKey:@"name"] forKey:@"item"];
	
	NSError *jsonError = nil;
	NSData *bodyData = [[CJSONSerializer serializer] serializeDictionary:dict error:&jsonError];
	if (jsonError != nil || bodyData == nil)
		return nil;
	
	[request setHTTPBody:bodyData];
	
	transaction.request = request;
	transaction.identifier = [NSString uniqueString];
	transaction.requestType = CLAPIRequestTypeItemUpdate;
	transaction.userInfo = userInfo;
	
	return [self _createAndStartConnectionForTransaction:transaction];
}

- (NSString *)changeNameOfItemAtHref:(NSURL *)href toName:(NSString *)newName userInfo:(id)userInfo
{
	CLWebItem *webItem = [CLWebItem webItem];
	webItem.href = href;
	return [self changeNameOfItem:webItem toName:newName userInfo:userInfo];
}

- (NSString *)changePrivacyOfItem:(CLWebItem *)webItem toPrivate:(BOOL)isPrivate userInfo:(id)userInfo {
	if (![self isReady] || webItem == nil || webItem.href == nil)
		return nil;
	
	CLAPITransaction *transaction = [CLAPITransaction transaction];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:webItem.href];
	[request setHTTPMethod:@"PUT"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
	NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:isPrivate ? @"true" : @"false" forKey:@"private"] forKey:@"item"];
	
	NSError *jsonError = nil;
	NSData *bodyData = [[CJSONSerializer serializer] serializeDictionary:dict error:&jsonError];
	if (jsonError != nil || bodyData == nil)
		return nil;
	
	[request setHTTPBody:bodyData];
	
	transaction.request = request;
	transaction.identifier = [NSString uniqueString];
	transaction.requestType = CLAPIRequestTypeItemUpdate;
	transaction.userInfo = userInfo;
	
	return [self _createAndStartConnectionForTransaction:transaction];
}

- (NSString *)changePrivacyOfItemAtHref:(NSURL *)href toPrivate:(BOOL)isPrivate userInfo:(id)userInfo
{
	CLWebItem *webItem = [CLWebItem webItem];
	webItem.href = href;
	return [self changePrivacyOfItem:webItem toPrivate:isPrivate userInfo:userInfo];
}

- (NSString *)getAccountInformationWithUserInfo:(id)userInfo {
	if (![self isReady])
		return nil;
	
	CLAPITransaction *transaction = [CLAPITransaction transaction];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/account", CLAPIEngineBaseURL]]];
	[request setHTTPMethod:@"GET"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	transaction.request = request;
	transaction.identifier = [NSString uniqueString];
	transaction.requestType = CLAPIRequestTypeGetAccountInformation;
	transaction.userInfo = userInfo;
	
	return [self _createAndStartConnectionForTransaction:transaction];
}

- (NSString *)bookmarkLinkWithURL:(NSURL *)URL name:(NSString *)name userInfo:(id)userInfo {
	if (![self isReady] || [[URL absoluteString] length] == 0)
		return nil;
	if ([name length] == 0)
		name = [URL absoluteString];
	
	CLAPITransaction *transaction = [CLAPITransaction transaction];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/items", CLAPIEngineBaseURL]]];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
	NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObjectsAndKeys:name, @"name", [URL absoluteString], @"redirect_url", nil] forKey:@"item"];
	
	NSError *jsonError = nil;
	NSData *bodyData = [[CJSONSerializer serializer] serializeDictionary:dict error:&jsonError];
	if (jsonError != nil || bodyData == nil)
		return nil;
	
	[request setHTTPBody:bodyData];
	
	transaction.request = request;
	transaction.identifier = [NSString uniqueString];
	transaction.requestType = CLAPIRequestTypeLinkBookmark;
	transaction.userInfo = userInfo;
	
	return [self _createAndStartConnectionForTransaction:transaction];
}

- (NSString *)deleteItem:(CLWebItem *)webItem userInfo:(id)userInfo {
	if (![self isReady] || webItem == nil || webItem.href == nil)
		return nil;
	
	CLAPITransaction *transaction = [CLAPITransaction transaction];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:webItem.href];
	[request setHTTPMethod:@"DELETE"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	transaction.request = request;
	transaction.identifier = [NSString uniqueString];
	transaction.requestType = CLAPIRequestTypeItemDeletion;
	transaction.userInfo = userInfo;
	
	return [self _createAndStartConnectionForTransaction:transaction];
}

- (NSString *)getItemInformationAtURL:(NSURL *)itemURL userInfo:(id)userInfo {
	CLWebItem *tempItem = [CLWebItem webItem];
	tempItem.URL = itemURL;
	return [self getItemInformation:tempItem userInfo:userInfo];
}

- (NSString *)getItemInformation:(CLWebItem *)webItem userInfo:(id)userInfo {
	if (webItem == nil || webItem.URL == nil)
		return nil;
	
	CLAPITransaction *transaction = [CLAPITransaction transaction];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:webItem.URL];
	[request setHTTPMethod:@"GET"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	transaction.request = request;
	transaction.identifier = [NSString uniqueString];
	transaction.requestType = CLAPIRequestTypeGetItemInformation;
	transaction.userInfo = userInfo;
	
	return [self _createAndStartConnectionForTransaction:transaction];
}

- (NSString *)deleteItemAtHref:(NSURL *)href userInfo:(id)userInfo {
	CLWebItem *tempItem = [CLWebItem webItem];
	tempItem.href = href;
	return [self deleteItem:tempItem userInfo:userInfo];
}

- (NSString *)getItemListStartingAtPage:(NSInteger)pageNumStartingAtOne itemsPerPage:(NSInteger)perPage userInfo:(id)userInfo {
	return [self getItemListStartingAtPage:pageNumStartingAtOne ofType:CLWebItemTypeNone itemsPerPage:perPage showOnlyItemsInTrash:NO userInfo:userInfo];
}

- (NSString *)getItemListStartingAtPage:(NSInteger)pageNumStartingAtOne ofType:(CLWebItemType)type itemsPerPage:(NSInteger)perPage userInfo:(id)userInfo {
	return [self getItemListStartingAtPage:pageNumStartingAtOne ofType:type itemsPerPage:perPage showOnlyItemsInTrash:NO userInfo:userInfo];
}

- (NSString *)getItemListStartingAtPage:(NSInteger)pageNumStartingAtOne ofType:(CLWebItemType)type itemsPerPage:(NSInteger)perPage showOnlyItemsInTrash:(BOOL)showOnlyItemsInTrash userInfo:(id)userInfo {
	if (![self isReady])
		return nil;
	
	CLAPITransaction *transaction = [CLAPITransaction transaction];
	NSString *urlString = [NSString stringWithFormat:@"%@/items?page=%i&per_page=%i&deleted=%@", CLAPIEngineBaseURL, pageNumStartingAtOne, perPage, showOnlyItemsInTrash ? @"true" : @"false"];
	if (type != CLWebItemTypeNone)
		urlString = [urlString stringByAppendingFormat:@"&type=%@", [CLAPISerializer webItemTypeStringForType:type]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"GET"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	transaction.request = request;
	transaction.identifier = [NSString uniqueString];
	transaction.requestType = CLAPIRequestTypeGetItemList;
	transaction.userInfo = userInfo;
	
	return [self _createAndStartConnectionForTransaction:transaction];
}

- (NSString *)uploadFileWithName:(NSString *)fileName fileData:(NSData *)fileData userInfo:(id)userInfo {
	
	if (![self isReady])
		return nil;
	
	CLAPITransaction *transaction = [CLAPITransaction transaction];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/items/new", CLAPIEngineBaseURL]]];
	[request setHTTPMethod:@"GET"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	transaction.request = request;
	transaction.identifier = [NSString uniqueString];
	transaction.requestType = CLAPIRequestTypeGetS3UploadCredentials;
	transaction.userInfo = userInfo;
	transaction.internalContext = [NSDictionary dictionaryWithObjectsAndKeys:fileName, @"name", fileData, @"data", nil];
	
	return [self _createAndStartConnectionForTransaction:transaction];
}

- (void)cancelConnection:(NSString *)connectionIdentifier {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@", connectionIdentifier];
	NSSet *resultSet = [self.transactions filteredSetUsingPredicate:predicate];
	CLAPITransaction *transaction = [resultSet anyObject];
	if (transaction) {
		[transaction.connection cancel];
		if ([self.transactions containsObject:transaction])
			[self.transactions removeObject:transaction];
	}
}

- (void)cancelAllConnections {
	NSMutableSet *transCopy = [[self.transactions mutableCopy] autorelease];
	for (CLAPITransaction *transaction in transCopy) {
		[self cancelConnection:transaction.identifier];
	}
}

- (id)userInfoForConnectionIdentifier:(NSString *)connectionIdentifier {
	CLAPITransaction *transaction = [self _transactionForConnectionIdentifier:connectionIdentifier];
	return [transaction userInfo];
}

- (CLAPIRequestType)requestTypeForConnectionIdentifier:(NSString *)connectionIdentifier {
	CLAPITransaction *transaction = [self _transactionForConnectionIdentifier:connectionIdentifier];
	return [transaction requestType];
}

#pragma mark -
#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[[self _transactionForConnection:connection].receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	if ([challenge previousFailureCount] == 0) {
		NSURLCredential *credential = [NSURLCredential credentialWithUser:[self.email lowercaseString] password:self.password persistence:NSURLCredentialPersistenceNone];
		[[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
	} else {
		[[challenge sender] cancelAuthenticationChallenge:challenge];
	}
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
	CLAPITransaction *transaction = [self _transactionForConnection:connection];
	if (transaction.requestType == CLAPIRequestTypeS3FileUpload) {
		CGFloat percentDone = (CGFloat)totalBytesWritten / (CGFloat)totalBytesExpectedToWrite;
		if ([self.delegate respondsToSelector:@selector(fileUploadDidProgress:connectionIdentifier:userInfo:)])
			[self.delegate fileUploadDidProgress:percentDone connectionIdentifier:transaction.identifier userInfo:transaction.userInfo];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
		CLAPITransaction *transaction = [self _transactionForConnection:connection];
		transaction.response = (NSHTTPURLResponse *)response;
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	if ([error code] == NSURLErrorUserCancelledAuthentication)
		error = [NSError errorWithDomain:[error domain] code:[error code] userInfo:[NSDictionary dictionaryWithObject:@"Authentication failed" forKey:NSLocalizedDescriptionKey]];
	
	CLAPITransaction *transaction = [self _transactionForConnection:connection];
	
	if ([self.delegate respondsToSelector:@selector(requestDidFailWithError:connectionIdentifier:userInfo:)])
		[self.delegate requestDidFailWithError:error connectionIdentifier:transaction.identifier userInfo:transaction.userInfo];
	
	if ([self.transactions containsObject:transaction])
		[self.transactions removeObject:transaction];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	CLAPITransaction *transaction = [self _transactionForConnection:connection];
	
	if (transaction.response.statusCode != 200) {
		[self connection:connection didFailWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Status code was not 200 (%i)", transaction.response.statusCode] forKey:NSLocalizedDescriptionKey]]];
		return;
	}
		 
	if (transaction.requestType != CLAPIRequestTypeGetS3UploadCredentials && 
		[self.delegate respondsToSelector:@selector(requestDidSucceedWithConnectionIdentifier:userInfo:)])
		[self.delegate requestDidSucceedWithConnectionIdentifier:transaction.identifier userInfo:transaction.userInfo];
	
	switch (transaction.requestType) {
		case CLAPIRequestTypeGetS3UploadCredentials: {
			NSError *jsonError = nil;
			NSDictionary *s3Dict = [[CJSONDeserializer deserializer] deserializeAsDictionary:transaction.receivedData error:&jsonError];
			if (jsonError != nil) {
				[self connection:connection didFailWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"S3 credentials dictionary invalid", transaction.response.statusCode] forKey:NSLocalizedDescriptionKey]]];
                return;
			}		
			
			if ([[s3Dict allKeys] containsObject:@"uploads_remaining"] && [[s3Dict objectForKey:@"uploads_remaining"] integerValue] <= 0) {
				[self connection:connection didFailWithError:[NSError errorWithDomain:NSURLErrorDomain code:CLUploadLimitExceeded userInfo:[NSDictionary dictionaryWithObject:@"Upload limit exceeded" forKey:NSLocalizedDescriptionKey]]];
				return;
			}
			
			NSData *fileData = [transaction.internalContext objectForKey:@"data"];
			
			if ([[s3Dict allKeys] containsObject:@"max_upload_size"] && [fileData length] > [[s3Dict objectForKey:@"max_upload_size"] integerValue]) {
				[self connection:connection didFailWithError:[NSError errorWithDomain:NSURLErrorDomain code:CLUploadSizeLimitExceeded userInfo:[NSDictionary dictionaryWithObject:@"Max upload size exceeded" forKey:NSLocalizedDescriptionKey]]];
				return;
			}
			
			NSURLRequest *request = [CLAPIDeserializer URLRequestWithS3ParametersDictionary:s3Dict fileName:[transaction.internalContext objectForKey:@"name"] fileData:fileData];
			CLAPITransaction *newTransaction = [CLAPITransaction transaction];
			newTransaction.identifier = transaction.identifier;
			newTransaction.userInfo = transaction.userInfo;
			newTransaction.request = request;
			newTransaction.requestType = CLAPIRequestTypeS3FileUpload;
			[self _createAndStartConnectionForTransaction:newTransaction];
			break;
		}
		case CLAPIRequestTypeS3FileUpload: {
			CLWebItem *resultItem = [CLAPIDeserializer webItemWithJSONDictionaryData:transaction.receivedData];
			if ([self.delegate respondsToSelector:@selector(fileUploadDidSucceedWithResultingItem:connectionIdentifier:userInfo:)])
				[self.delegate fileUploadDidSucceedWithResultingItem:resultItem connectionIdentifier:transaction.identifier userInfo:transaction.userInfo];
			break;
		}
		case CLAPIRequestTypeAccountUpdate: {
			CLAccount *resultAccount = [CLAPIDeserializer accountWithJSONDictionaryData:transaction.receivedData];
			if ([self.delegate respondsToSelector:@selector(accountUpdateDidSucceed:connectionIdentifier:userInfo:)])
				[self.delegate accountUpdateDidSucceed:resultAccount connectionIdentifier:transaction.identifier userInfo:transaction.userInfo];
			break;
		}
		case CLAPIRequestTypeItemUpdate: {
			CLWebItem *resultItem = [CLAPIDeserializer webItemWithJSONDictionaryData:transaction.receivedData];
			if ([self.delegate respondsToSelector:@selector(itemUpdateDidSucceed:connectionIdentifier:userInfo:)])
				[self.delegate itemUpdateDidSucceed:resultItem connectionIdentifier:transaction.identifier userInfo:transaction.userInfo];
			break;
		}
		case CLAPIRequestTypeItemDeletion: {
			CLWebItem *resultItem = [CLAPIDeserializer webItemWithJSONDictionaryData:transaction.receivedData];
			if ([self.delegate respondsToSelector:@selector(itemDeletionDidSucceed:connectionIdentifier:userInfo:)])
				[self.delegate itemDeletionDidSucceed:resultItem connectionIdentifier:transaction.identifier userInfo:transaction.userInfo];
			break;
		}
		case CLAPIRequestTypeGetItemList: {
			NSArray *itemArray = [CLAPIDeserializer webItemArrayWithJSONArrayData:transaction.receivedData];
			if ([self.delegate respondsToSelector:@selector(itemListRetrievalSucceeded:connectionIdentifier:userInfo:)])
				[self.delegate itemListRetrievalSucceeded:itemArray connectionIdentifier:transaction.identifier userInfo:transaction.userInfo];
			break;
		}
		case CLAPIRequestTypeLinkBookmark: {
			CLWebItem *resultItem = [CLAPIDeserializer webItemWithJSONDictionaryData:transaction.receivedData];
			if ([self.delegate respondsToSelector:@selector(linkBookmarkDidSucceedWithResultingItem:connectionIdentifier:userInfo:)])
				[self.delegate linkBookmarkDidSucceedWithResultingItem:resultItem connectionIdentifier:transaction.identifier userInfo:transaction.userInfo];
			break;
		}
		case CLAPIRequestTypeCreateAccount: {
			CLAccount *resultAccount = [CLAPIDeserializer accountWithJSONDictionaryData:transaction.receivedData];
			if ([self.delegate respondsToSelector:@selector(accountCreationSucceeded:connectionIdentifier:userInfo:)])
				[self.delegate accountCreationSucceeded:resultAccount connectionIdentifier:transaction.identifier userInfo:transaction.userInfo];
			break;
		}
		case CLAPIRequestTypeGetAccountInformation: {
			CLAccount *resultAccount = [CLAPIDeserializer accountWithJSONDictionaryData:transaction.receivedData];
			if ([self.delegate respondsToSelector:@selector(accountInformationRetrievalSucceeded:connectionIdentifier:userInfo:)])
				[self.delegate accountInformationRetrievalSucceeded:resultAccount connectionIdentifier:transaction.identifier userInfo:transaction.userInfo];
			break;
		}
		case CLAPIRequestTypeGetItemInformation: {
			CLWebItem *resultItem = [CLAPIDeserializer webItemWithJSONDictionaryData:transaction.receivedData];
			if ([self.delegate respondsToSelector:@selector(itemInformationRetrievalSucceeded:connectionIdentifier:userInfo:)])
				[self.delegate itemInformationRetrievalSucceeded:resultItem connectionIdentifier:transaction.identifier userInfo:transaction.userInfo];
			break;
		}
	}
	if ([self.transactions containsObject:transaction])
		[self.transactions removeObject:transaction];
}

#pragma mark -
#pragma mark Private Methods

- (NSString *)_createAndStartConnectionForTransaction:(CLAPITransaction *)transaction {
	if (self.clearsCookies) {
		NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:CLAPIEngineBaseURL]];
		for (NSHTTPCookie *currCookie in cookies)
			[[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:currCookie];
	}

	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:transaction.request delegate:self startImmediately:NO];
	[connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	transaction.connection = connection;
	[self.transactions addObject:transaction];
	[connection start];
	[connection release];
	
	return transaction.identifier;
}

- (CLAPITransaction *)_transactionForConnection:(NSURLConnection *)connection {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"connection = %@", connection];
	NSSet *resultSet = [self.transactions filteredSetUsingPredicate:predicate];
	return [resultSet anyObject];
}

- (CLAPITransaction *)_transactionForConnectionIdentifier:(NSString *)connectionIdentifier {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@", connectionIdentifier];
	NSSet *resultSet = [self.transactions filteredSetUsingPredicate:predicate];
	return [resultSet anyObject];
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc {
	self.email = nil;
	self.password = nil;
	self.delegate = nil;
	self.transactions = nil;
	
	[super dealloc];
}

@end
