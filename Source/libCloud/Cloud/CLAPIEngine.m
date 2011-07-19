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
#import "CLAPIDeserializer.h"
#import "CLAPISerializer.h"
#import "NSString+NPAdditions.h"


static NSString *_CLAPIEngineBaseURL = @"http://my.cl.ly";

NSString *const CLAPIEngineUploadOptionPrivacyKey = @"CLAPIEngineUploadOptionPrivacy"; // Value is CLAPIEnginePrivacyOptionPrivate or CLAPIEnginePrivacyOptionPublic

NSString *const CLAPIEnginePrivacyOptionPrivate = @"private";
NSString *const CLAPIEnginePrivacyOptionPublic = @"public";


@interface CLAPIEngine ()

- (NSURL *)_URLWithPath:(NSString *)path;

- (NSString *)_createAndStartConnectionForTransaction:(CLAPITransaction *)transaction;
- (CLAPITransaction *)_transactionForConnection:(NSURLConnection *)connection;
- (CLAPITransaction *)_transactionForConnectionIdentifier:(NSString *)connectionIdentifier;

@end


@implementation CLAPIEngine

@synthesize email = _email, password = _password, delegate = _delegate, baseURL = _baseURL, clearsCookies = _clearsCookies,
			transactions = _transactions;

+ (void)initialize
{
    if (self == [CLAPIEngine class]) {
        // This is for testing against another server.
        NSString *possibleURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"CloudAppBaseURL"];
        if ([possibleURL length] > 0)
            _CLAPIEngineBaseURL = possibleURL;
    }
}

- (id)init
{
	return [self initWithDelegate:nil];
}

- (id)initWithDelegate:(id<CLAPIEngineDelegate>)aDelegate
{
	if ((self = [super init])) {
		_delegate      = aDelegate;
		_transactions  = [[NSMutableSet alloc] init];
		_clearsCookies = NO;
        _baseURL       = [[[self class] defaultBaseURL] retain];
	}
	return self;
}

+ (id)engine
{
	return [[[[self class] alloc] init] autorelease];
}

+ (id)engineWithDelegate:(id<CLAPIEngineDelegate>)aDelegate
{
	return [[[[self class] alloc] initWithDelegate:aDelegate] autorelease];
}

- (BOOL)isReady
{
	return (self.email != nil && [self.email length] > 0 && self.password != nil && [self.password length] > 0);
}

+ (NSURL *)defaultBaseURL
{
    return [NSURL URLWithString:_CLAPIEngineBaseURL];
}

#pragma mark - Actions

- (NSString *)createAccountWithEmail:(NSString *)accountEmail password:(NSString *)accountPassword acceptTerms:(BOOL)acceptTerms userInfo:(id)userInfo
{
	if (accountEmail == nil || accountPassword == nil)
		return nil;
	
	CLAPITransaction *transaction = [CLAPITransaction transaction];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self _URLWithPath:@"/register"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
	NSData *bodyData = [CLAPISerializer accountWithEmail:accountEmail
                                                password:accountPassword
                                             acceptTerms:acceptTerms];
	if (bodyData == nil)
		return nil;
	
	[request setHTTPBody:bodyData];
	
	transaction.request     = request;
	transaction.identifier  = [NSString uniqueString];
	transaction.requestType = CLAPIRequestTypeCreateAccount;
	transaction.userInfo    = userInfo;
	
	return [self _createAndStartConnectionForTransaction:transaction];
}

- (NSString *)changeNameOfItem:(CLWebItem *)webItem toName:(NSString *)newName userInfo:(id)userInfo
{
	if (![self isReady] || webItem == nil || webItem.href == nil)
		return nil;
	
	CLAPITransaction *transaction = [CLAPITransaction transaction];
	NSMutableURLRequest *request  = [NSMutableURLRequest requestWithURL:webItem.href];
	[request setHTTPMethod:@"PUT"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
	NSData *bodyData = [CLAPISerializer itemWithName:newName];
	if (bodyData == nil)
		return nil;
	
	[request setHTTPBody:bodyData];
	
	transaction.request     = request;
	transaction.identifier  = [NSString uniqueString];
	transaction.requestType = CLAPIRequestTypeItemUpdateName;
	transaction.userInfo    = userInfo;
	
	return [self _createAndStartConnectionForTransaction:transaction];
}

- (NSString *)changeNameOfItemAtHref:(NSURL *)href toName:(NSString *)newName userInfo:(id)userInfo
{
	CLWebItem *webItem = [CLWebItem webItem];
	webItem.href = href;
    
	return [self changeNameOfItem:webItem toName:newName userInfo:userInfo];
}

- (NSString *)changePrivacyOfItem:(CLWebItem *)webItem toPrivate:(BOOL)isPrivate userInfo:(id)userInfo
{
	if (![self isReady] || webItem == nil || webItem.href == nil)
		return nil;
	
	CLAPITransaction *transaction = [CLAPITransaction transaction];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:webItem.href];
	[request setHTTPMethod:@"PUT"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
	NSData *bodyData = [CLAPISerializer itemWithPrivate:isPrivate];
	if (bodyData == nil)
		return nil;
	
	[request setHTTPBody:bodyData];
	
	transaction.request     = request;
	transaction.identifier  = [NSString uniqueString];
	transaction.requestType = CLAPIRequestTypeItemUpdatePrivacy;
	transaction.userInfo    = userInfo;
	
	return [self _createAndStartConnectionForTransaction:transaction];
}

- (NSString *)changePrivacyOfItemAtHref:(NSURL *)href toPrivate:(BOOL)isPrivate userInfo:(id)userInfo
{
	CLWebItem *webItem = [CLWebItem webItem];
	webItem.href = href;
    
	return [self changePrivacyOfItem:webItem toPrivate:isPrivate userInfo:userInfo];
}

- (NSString *)getAccountInformationWithUserInfo:(id)userInfo
{
	if (![self isReady])
		return nil;
	
	CLAPITransaction *transaction = [CLAPITransaction transaction];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self _URLWithPath:@"/account"]];
	[request setHTTPMethod:@"GET"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
	
	transaction.request     = request;
	transaction.identifier  = [NSString uniqueString];
	transaction.requestType = CLAPIRequestTypeGetAccountInformation;
	transaction.userInfo    = userInfo;
	
	return [self _createAndStartConnectionForTransaction:transaction];
}

- (NSString *)bookmarkLinkWithURL:(NSURL *)URL name:(NSString *)name userInfo:(id)userInfo
{
    return [self bookmarkLinkWithURL:URL name:name options:nil userInfo:userInfo];
}

- (NSString *)bookmarkLinkWithURL:(NSURL *)URL name:(NSString *)name options:(NSDictionary *)options userInfo:(id)userInfo
{
    if (![self isReady] || [[URL absoluteString] length] == 0)
		return nil;
    
	if ([name length] == 0)
		name = [URL absoluteString];
	
	CLAPITransaction *transaction = [CLAPITransaction transaction];
    
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self _URLWithPath:@"/items"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
    NSData *bodyData = nil;
    
    if ([options.allKeys containsObject:CLAPIEngineUploadOptionPrivacyKey]) {
        NSString *privacySetting = [options objectForKey:CLAPIEngineUploadOptionPrivacyKey];
        if ([privacySetting isEqualToString:CLAPIEnginePrivacyOptionPublic]) {
            bodyData = [CLAPISerializer bookmarkWithURL:URL name:name private:NO];
        } else if ([privacySetting isEqualToString:CLAPIEnginePrivacyOptionPrivate]) {
            bodyData = [CLAPISerializer bookmarkWithURL:URL name:name private:YES];
        } else {
            bodyData = [CLAPISerializer bookmarkWithURL:URL name:name];
        }
    } else {
        bodyData = [CLAPISerializer bookmarkWithURL:URL name:name];
    }
	if (bodyData == nil)
		return nil;
	
	[request setHTTPBody:bodyData];
	
	transaction.request     = request;
	transaction.identifier  = [NSString uniqueString];
	transaction.requestType = CLAPIRequestTypeLinkBookmark;
	transaction.userInfo    = userInfo;
	
	return [self _createAndStartConnectionForTransaction:transaction];
}

- (NSString *)restoreItem:(CLWebItem *)webItem userInfo:(id)userInfo
{
    if (![self isReady] || webItem == nil || webItem.href == nil)
		return nil;
	
	CLAPITransaction *transaction = [CLAPITransaction transaction];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:webItem.href];
	[request setHTTPMethod:@"PUT"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
	NSData *bodyData = [CLAPISerializer itemForRestore];
	if (bodyData == nil)
		return nil;
	
	[request setHTTPBody:bodyData];
	
	transaction.request     = request;
	transaction.identifier  = [NSString uniqueString];
	transaction.requestType = CLAPIRequestTypeItemRestoration;
	transaction.userInfo    = userInfo;
	
	return [self _createAndStartConnectionForTransaction:transaction];
}

- (NSString *)restoreItemAtHref:(NSURL *)href userInfo:(id)userInfo
{
    CLWebItem *tempItem = [CLWebItem webItem];
	tempItem.href = href;
    
	return [self restoreItem:tempItem userInfo:userInfo];
}

- (NSString *)deleteItem:(CLWebItem *)webItem userInfo:(id)userInfo
{
	if (![self isReady] || webItem == nil || webItem.href == nil)
		return nil;
	
	CLAPITransaction *transaction = [CLAPITransaction transaction];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:webItem.href];
	[request setHTTPMethod:@"DELETE"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	transaction.request     = request;
	transaction.identifier  = [NSString uniqueString];
	transaction.requestType = CLAPIRequestTypeItemDeletion;
	transaction.userInfo    = userInfo;
	
	return [self _createAndStartConnectionForTransaction:transaction];
}

- (NSString *)getItemInformationAtURL:(NSURL *)itemURL userInfo:(id)userInfo
{
	CLWebItem *tempItem = [CLWebItem webItem];
	tempItem.URL = itemURL;
    
	return [self getItemInformation:tempItem userInfo:userInfo];
}

- (NSString *)getItemInformation:(CLWebItem *)webItem userInfo:(id)userInfo
{
	if (webItem == nil || webItem.URL == nil)
		return nil;
	
	CLAPITransaction *transaction = [CLAPITransaction transaction];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:webItem.URL];
	[request setHTTPMethod:@"GET"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	transaction.request     = request;
	transaction.identifier  = [NSString uniqueString];
	transaction.requestType = CLAPIRequestTypeGetItemInformation;
	transaction.userInfo    = userInfo;
	
	return [self _createAndStartConnectionForTransaction:transaction];
}

- (NSString *)deleteItemAtHref:(NSURL *)href userInfo:(id)userInfo
{
	CLWebItem *tempItem = [CLWebItem webItem];
	tempItem.href = href;
    
	return [self deleteItem:tempItem userInfo:userInfo];
}

- (NSString *)getItemListStartingAtPage:(NSInteger)pageNumStartingAtOne itemsPerPage:(NSInteger)perPage userInfo:(id)userInfo
{
	return [self getItemListStartingAtPage:pageNumStartingAtOne
                                    ofType:CLWebItemTypeNone
                              itemsPerPage:perPage
                      showOnlyItemsInTrash:NO
                                  userInfo:userInfo];
}

- (NSString *)getItemListStartingAtPage:(NSInteger)pageNumStartingAtOne ofType:(CLWebItemType)type itemsPerPage:(NSInteger)perPage userInfo:(id)userInfo
{
	return [self getItemListStartingAtPage:pageNumStartingAtOne
                                    ofType:type
                              itemsPerPage:perPage
                      showOnlyItemsInTrash:NO
                                  userInfo:userInfo];
}

- (NSString *)getItemListStartingAtPage:(NSInteger)pageNumStartingAtOne ofType:(CLWebItemType)type itemsPerPage:(NSInteger)perPage showOnlyItemsInTrash:(BOOL)showOnlyItemsInTrash userInfo:(id)userInfo
{
	if (![self isReady])
		return nil;
	
	CLAPITransaction *transaction = [CLAPITransaction transaction];
    
    static NSString *format = @"/items?page=%i&per_page=%i&deleted=%@";
    NSString *path = [NSString stringWithFormat:format, pageNumStartingAtOne, perPage, showOnlyItemsInTrash ? @"true" : @"false"];
    if (type != CLWebItemTypeNone)
		path = [path stringByAppendingFormat:@"&type=%@", [CLAPISerializer webItemTypeStringForType:type]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self _URLWithPath:path]];
	[request setHTTPMethod:@"GET"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	transaction.request     = request;
	transaction.identifier  = [NSString uniqueString];
	transaction.requestType = CLAPIRequestTypeGetItemList;
	transaction.userInfo    = userInfo;
	
	return [self _createAndStartConnectionForTransaction:transaction];
}

- (NSString *)uploadFileWithName:(NSString *)fileName fileData:(NSData *)fileData userInfo:(id)userInfo
{	
    return [self uploadFileWithName:fileName fileData:fileData options:nil userInfo:userInfo];
}

- (NSString *)uploadFileWithName:(NSString *)fileName fileData:(NSData *)fileData options:(NSDictionary *)options userInfo:(id)userInfo
{
    if (![self isReady])
		return nil;
    
    
    NSURL *apiURL = [self _URLWithPath:@"/items/new"];
    if ([options.allKeys containsObject:CLAPIEngineUploadOptionPrivacyKey]) {
        NSString *apiURLString = [apiURL absoluteString];
        NSString *privacyOption = [options objectForKey:CLAPIEngineUploadOptionPrivacyKey];
        if ([privacyOption isEqualToString:CLAPIEnginePrivacyOptionPublic])
            apiURLString = [apiURLString stringByAppendingString:@"?item[private]=false"];
        else if ([privacyOption isEqualToString:CLAPIEnginePrivacyOptionPrivate])
            apiURLString = [apiURLString stringByAppendingString:@"?item[private]=true"];
        
        apiURL = [NSURL URLWithString:apiURLString];
    }
    
    // Make sure that the API URL is still valid after the editing
    if (apiURL == nil)
        return nil;

	
	CLAPITransaction *transaction = [CLAPITransaction transaction];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:apiURL];
	[request setHTTPMethod:@"GET"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	transaction.request         = request;
	transaction.identifier      = [NSString uniqueString];
	transaction.requestType     = CLAPIRequestTypeGetS3UploadCredentials;
	transaction.userInfo        = userInfo;
	transaction.internalContext = [NSDictionary dictionaryWithObjectsAndKeys:fileName, @"name",
                                   fileData, @"data", nil];
	
	return [self _createAndStartConnectionForTransaction:transaction];
}

#pragma mark -

- (NSString *)getStoreProductsWithUserInfo:(id)userInfo
{
    CLAPITransaction *transaction = [CLAPITransaction transaction];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self _URLWithPath:@"/purchases"]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData]; // disable caching
    
    transaction.request     = request;
	transaction.identifier  = [NSString uniqueString];
	transaction.requestType = CLAPIRequestTypeGetStoreProducts;
	transaction.userInfo    = userInfo;
	
	return [self _createAndStartConnectionForTransaction:transaction];
}

- (NSString *)redeemStoreReceipt:(NSString *)base64Receipt userInfo:(id)userInfo
{
    if (![self isReady]) {
        return  nil;
    }
    
    CLAPITransaction *transaction = [CLAPITransaction transaction];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self _URLWithPath:@"/purchases"]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[CLAPISerializer receiptWithBase64String:base64Receipt]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData]; // disable caching
    
    transaction.request     = request;
	transaction.identifier  = [NSString uniqueString];
	transaction.requestType = CLAPIRequestTypeStoreReceiptRedemption;
	transaction.userInfo    = userInfo;
	
	return [self _createAndStartConnectionForTransaction:transaction];
}

#pragma mark - Connection actions

- (void)cancelConnection:(NSString *)connectionIdentifier
{
	CLAPITransaction *transaction = [self _transactionForConnectionIdentifier:connectionIdentifier];
	if (transaction) {
        // Cancel transaction
		[transaction.connection cancel];
		if ([self.transactions containsObject:transaction])
			[self.transactions removeObject:transaction];
	}
}

- (void)cancelAllConnections
{
	NSMutableSet *transCopy = [[self.transactions mutableCopy] autorelease];
	for (CLAPITransaction *transaction in transCopy) {
		[self cancelConnection:transaction.identifier];
	}
}

- (id)userInfoForConnectionIdentifier:(NSString *)connectionIdentifier
{
	CLAPITransaction *transaction = [self _transactionForConnectionIdentifier:connectionIdentifier];
	return [transaction userInfo];
}

- (CLAPIRequestType)requestTypeForConnectionIdentifier:(NSString *)connectionIdentifier
{
	CLAPITransaction *transaction = [self _transactionForConnectionIdentifier:connectionIdentifier];
	return [transaction requestType];
}

#pragma mark -
#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[[self _transactionForConnection:connection].receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	if ([challenge previousFailureCount] == 0) {
        // Return credentials
		NSURLCredential *credential = [NSURLCredential credentialWithUser:[self.email lowercaseString]
                                                                 password:self.password
                                                              persistence:NSURLCredentialPersistenceNone];
		[[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
        
	} else {
        // Cancel challenge if it failed previously
		[[challenge sender] cancelAuthenticationChallenge:challenge];
	}
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten
 totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
	CLAPITransaction *transaction = [self _transactionForConnection:connection];
	if (transaction.requestType == CLAPIRequestTypeS3FileUpload) {
        // Calculate percentage and inform delegate
		CGFloat percentDone = (CGFloat)totalBytesWritten / (CGFloat)totalBytesExpectedToWrite;
        
		if ([self.delegate respondsToSelector:@selector(fileUploadDidProgress:connectionIdentifier:userInfo:)])
			[self.delegate fileUploadDidProgress:percentDone
                            connectionIdentifier:transaction.identifier
                                        userInfo:transaction.userInfo];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
		CLAPITransaction *transaction = [self _transactionForConnection:connection];
		transaction.response = (NSHTTPURLResponse *)response;
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	CLAPITransaction *transaction = [self _transactionForConnection:connection];
	
    // Inform delegate
	if ([self.delegate respondsToSelector:@selector(requestDidFailWithError:connectionIdentifier:userInfo:)])
		[self.delegate requestDidFailWithError:error connectionIdentifier:transaction.identifier userInfo:transaction.userInfo];
	
	if ([self.transactions containsObject:transaction])
		[self.transactions removeObject:transaction];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	CLAPITransaction *transaction = [self _transactionForConnection:connection];
    NSInteger statusCode = transaction.response.statusCode;
    CLAPIRequestType requestType = transaction.requestType;
    
	if (statusCode != 200 && statusCode != 201 && statusCode != 304) {
        // Try to parse the response
        NSArray *array = [CLAPIDeserializer arrayFromJSONData:transaction.receivedData];
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        
        // Add the request type
        [userInfo setObject:[NSNumber numberWithInteger:requestType]
                     forKey:CLAPIEngineErrorRequestTypeKey];
        [userInfo setObject:[NSNumber numberWithInteger:statusCode]
                     forKey:CLAPIEngineErrorStatusCodeKey];
        if (array) {
            // Add the error messages
            [userInfo setObject:array
                         forKey:CLAPIEngineErrorMessagesKey];
            
            // Add recovery suggestion
            NSMutableString *recoverySuggestion = [NSMutableString string];
            for (NSString *message in array) {
                [recoverySuggestion appendFormat:@"• %@\n", message];
            }
            [userInfo setObject:recoverySuggestion
                         forKey:NSLocalizedRecoverySuggestionErrorKey];
        }
        
        // TODO: get status code from response body for API 1.1
        NSError *error = [NSError errorWithDomain:CLAPIEngineErrorDomain
                                             code:CLAPIEngineErrorUnknown
                                         userInfo:userInfo];
		[self connection:connection didFailWithError:error];
		return;
	}
    
    // Do not notify for the delegate on S3 upload credentials request
	if (requestType != CLAPIRequestTypeGetS3UploadCredentials) {
        if ([self.delegate respondsToSelector:@selector(requestDidSucceedWithConnectionIdentifier:userInfo:)]) {
            [self.delegate requestDidSucceedWithConnectionIdentifier:transaction.identifier userInfo:transaction.userInfo];
        }
    }
	
	switch (requestType) {
		case CLAPIRequestTypeGetS3UploadCredentials: {
            // S3 credentials
			NSDictionary *s3Dict = [CLAPIDeserializer dictionaryFromJSONData:transaction.receivedData];
			if (s3Dict == nil) {
                NSError *error = [NSError errorWithDomain:NSURLErrorDomain
                                                     code:NSURLErrorBadServerResponse
                                                 userInfo:nil];
                [self connection:connection didFailWithError:error];
                return;
			}		
			
            // TODO: implement new error handling for API 1.1
            // Check if upload limit has been exceeded
            NSInteger remainingUploads = [[s3Dict objectForKey:@"uploads_remaining"] integerValue];
            if (remainingUploads <= 0 && [[s3Dict allKeys] containsObject:@"uploads_remaining"]) {
                // Limit exceeded, create user info dict & error
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                
                // Add the request type
                [userInfo setObject:[NSNumber numberWithInteger:requestType]
                             forKey:CLAPIEngineErrorRequestTypeKey];
                // Add error message
                NSString *errorMessage = @"You've reached the daily upload limit allowed by the Free plan. Grab one of our snazzy Pro plans and never see this message again.";
                [userInfo setObject:[NSArray arrayWithObject:errorMessage]
                             forKey:CLAPIEngineErrorMessagesKey];
                [userInfo setObject:errorMessage
                             forKey:NSLocalizedRecoverySuggestionErrorKey];
                [userInfo setObject:[NSNumber numberWithInteger:statusCode]
                             forKey:CLAPIEngineErrorStatusCodeKey];
                
                NSError *error = [NSError errorWithDomain:CLAPIEngineErrorDomain
                                                     code:CLAPIEngineErrorUploadLimitExceeded
                                                 userInfo:userInfo];
                
				[self connection:connection didFailWithError:error];
                return;
            }
			
            // Check if file is too big
			NSData *fileData = [transaction.internalContext objectForKey:@"data"];
            NSUInteger maxUploadSize = [[s3Dict objectForKey:@"max_upload_size"] unsignedIntegerValue];
            NSUInteger fileSize = [fileData length];
			if (maxUploadSize < fileSize && [[s3Dict allKeys] containsObject:@"max_upload_size"]) {
                // Too big, create user info dict & error
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                
                // Add the request type
                [userInfo setObject:[NSNumber numberWithInteger:requestType]
                             forKey:CLAPIEngineErrorRequestTypeKey];
                // Add error message
                NSString *format = @"This file is too large. You can upload files up to %dMB but this file is %dMB.";
                NSString *errorMessage = [NSString stringWithFormat:format, (int)(maxUploadSize / (1024 * 1024)),
                                                                    (int)(fileSize / (1024 * 1024))];
                [userInfo setObject:[NSArray arrayWithObject:errorMessage]
                             forKey:CLAPIEngineErrorMessagesKey];
                [userInfo setObject:errorMessage
                             forKey:NSLocalizedRecoverySuggestionErrorKey];
                [userInfo setObject:[NSNumber numberWithInteger:statusCode]
                             forKey:CLAPIEngineErrorStatusCodeKey];
                
                NSError *error = [NSError errorWithDomain:CLAPIEngineErrorDomain
                                                     code:CLAPIEngineErrorUploadTooLarge
                                                 userInfo:userInfo];
                
				[self connection:connection didFailWithError:error];
				return;
			}
			
            // Upload file
			NSURLRequest *request = [CLAPIDeserializer URLRequestWithS3ParametersDictionary:s3Dict
                                                                                   fileName:[transaction.internalContext objectForKey:@"name"]
                                                                                   fileData:fileData];
			CLAPITransaction *newTransaction = [CLAPITransaction transaction];
			newTransaction.identifier  = transaction.identifier;
			newTransaction.userInfo    = transaction.userInfo;
			newTransaction.request     = request;
			newTransaction.requestType = CLAPIRequestTypeS3FileUpload;
            
			[self _createAndStartConnectionForTransaction:newTransaction];
			break;
		}
            
		case CLAPIRequestTypeS3FileUpload: {
			CLWebItem *resultItem = [CLAPIDeserializer webItemWithJSONDictionaryData:transaction.receivedData];
			if ([self.delegate respondsToSelector:@selector(fileUploadDidSucceedWithResultingItem:connectionIdentifier:userInfo:)])
				[self.delegate fileUploadDidSucceedWithResultingItem:resultItem
                                                connectionIdentifier:transaction.identifier
                                                            userInfo:transaction.userInfo];
			break;
		}
            
		case CLAPIRequestTypeAccountUpdate: {
			CLAccount *resultAccount = [CLAPIDeserializer accountWithJSONDictionaryData:transaction.receivedData];
			if ([self.delegate respondsToSelector:@selector(accountUpdateDidSucceed:connectionIdentifier:userInfo:)])
				[self.delegate accountUpdateDidSucceed:resultAccount
                                  connectionIdentifier:transaction.identifier
                                              userInfo:transaction.userInfo];
			break;
		}
            
		case CLAPIRequestTypeItemUpdatePrivacy:
        case CLAPIRequestTypeItemUpdateName: {
			CLWebItem *resultItem = [CLAPIDeserializer webItemWithJSONDictionaryData:transaction.receivedData];
			if ([self.delegate respondsToSelector:@selector(itemUpdateDidSucceed:connectionIdentifier:userInfo:)])
				[self.delegate itemUpdateDidSucceed:resultItem
                               connectionIdentifier:transaction.identifier
                                           userInfo:transaction.userInfo];
			break;
		}
            
		case CLAPIRequestTypeItemDeletion: {
			CLWebItem *resultItem = [CLAPIDeserializer webItemWithJSONDictionaryData:transaction.receivedData];
			if ([self.delegate respondsToSelector:@selector(itemDeletionDidSucceed:connectionIdentifier:userInfo:)])
				[self.delegate itemDeletionDidSucceed:resultItem
                                 connectionIdentifier:transaction.identifier
                                             userInfo:transaction.userInfo];
			break;
		}
            
        case CLAPIRequestTypeItemRestoration: {
			CLWebItem *resultItem = [CLAPIDeserializer webItemWithJSONDictionaryData:transaction.receivedData];
			if ([self.delegate respondsToSelector:@selector(itemRestorationDidSucceed:connectionIdentifier:userInfo:)])
				[self.delegate itemRestorationDidSucceed:resultItem
                                    connectionIdentifier:transaction.identifier
                                                userInfo:transaction.userInfo];
			break;
		}
            
		case CLAPIRequestTypeGetItemList: {
			NSArray *itemArray = [CLAPIDeserializer webItemArrayWithJSONArrayData:transaction.receivedData];
			if ([self.delegate respondsToSelector:@selector(itemListRetrievalSucceeded:connectionIdentifier:userInfo:)])
				[self.delegate itemListRetrievalSucceeded:itemArray
                                     connectionIdentifier:transaction.identifier
                                                 userInfo:transaction.userInfo];
			break;
		}
            
		case CLAPIRequestTypeLinkBookmark: {
			CLWebItem *resultItem = [CLAPIDeserializer webItemWithJSONDictionaryData:transaction.receivedData];
			if ([self.delegate respondsToSelector:@selector(linkBookmarkDidSucceedWithResultingItem:connectionIdentifier:userInfo:)])
				[self.delegate linkBookmarkDidSucceedWithResultingItem:resultItem
                                                  connectionIdentifier:transaction.identifier
                                                              userInfo:transaction.userInfo];
			break;
		}
            
		case CLAPIRequestTypeCreateAccount: {
			CLAccount *resultAccount = [CLAPIDeserializer accountWithJSONDictionaryData:transaction.receivedData];
			if ([self.delegate respondsToSelector:@selector(accountCreationSucceeded:connectionIdentifier:userInfo:)])
				[self.delegate accountCreationSucceeded:resultAccount
                                   connectionIdentifier:transaction.identifier
                                               userInfo:transaction.userInfo];
			break;
		}
            
		case CLAPIRequestTypeGetAccountInformation: {
			CLAccount *resultAccount = [CLAPIDeserializer accountWithJSONDictionaryData:transaction.receivedData];
			if ([self.delegate respondsToSelector:@selector(accountInformationRetrievalSucceeded:connectionIdentifier:userInfo:)])
				[self.delegate accountInformationRetrievalSucceeded:resultAccount
                                               connectionIdentifier:transaction.identifier
                                                           userInfo:transaction.userInfo];
			break;
		}
            
		case CLAPIRequestTypeGetItemInformation: {
			CLWebItem *resultItem = [CLAPIDeserializer webItemWithJSONDictionaryData:transaction.receivedData];
			if ([self.delegate respondsToSelector:@selector(itemInformationRetrievalSucceeded:connectionIdentifier:userInfo:)])
				[self.delegate itemInformationRetrievalSucceeded:resultItem
                                            connectionIdentifier:transaction.identifier
                                                        userInfo:transaction.userInfo];
			break;
		}
            
        case CLAPIRequestTypeGetStoreProducts: {
            // Did receive store product identifiers
            NSArray *products = [CLAPIDeserializer productsWithJSONArrayData:transaction.receivedData];
            if ([self.delegate respondsToSelector:@selector(storeProductInformationRetrievalSucceeded:connectionIdentifier:userInfo:)]) {
                [self.delegate storeProductInformationRetrievalSucceeded:products
                                                    connectionIdentifier:transaction.identifier
                                                                userInfo:transaction.userInfo];
            }
            break;
        }
            
        case CLAPIRequestTypeStoreReceiptRedemption: {
            // Redemption of pro complete, return updated account
            CLAccount *account = [CLAPIDeserializer accountWithJSONDictionaryData:transaction.receivedData];
            if ([self.delegate respondsToSelector:@selector(storeReceiptRedemptionSucceeded:connectionIdentifier:userInfo:)]) {
                [self.delegate storeReceiptRedemptionSucceeded:account
                                          connectionIdentifier:transaction.identifier
                                                      userInfo:transaction.userInfo];
            }
            break;
        }
	}
    
	if ([self.transactions containsObject:transaction])
		[self.transactions removeObject:transaction];
}

#pragma mark -
#pragma mark Private Methods

- (NSString *)_createAndStartConnectionForTransaction:(CLAPITransaction *)transaction
{
	if (self.clearsCookies) {
        // Clear cookies
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
		NSArray *cookies = [storage cookiesForURL:self.baseURL];
		for (NSHTTPCookie *currCookie in cookies)
			[storage deleteCookie:currCookie];
	}

    // Create & start connection
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:transaction.request
                                                                  delegate:self
                                                          startImmediately:NO];
	[connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	transaction.connection = connection;
	[self.transactions addObject:transaction];
	[connection start];
	[connection release];
	
	return transaction.identifier;
}

- (CLAPITransaction *)_transactionForConnection:(NSURLConnection *)connection
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"connection = %@", connection];
	NSSet *resultSet = [self.transactions filteredSetUsingPredicate:predicate];
	return [resultSet anyObject];
}

- (CLAPITransaction *)_transactionForConnectionIdentifier:(NSString *)connectionIdentifier
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@", connectionIdentifier];
	NSSet *resultSet = [self.transactions filteredSetUsingPredicate:predicate];
	return [resultSet anyObject];
}

#pragma mark - Private accessors

- (NSURL *)_URLWithPath:(NSString *)path
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@", _CLAPIEngineBaseURL, path];
    return [NSURL URLWithString:URLString];
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc
{
    [self cancelAllConnections];
    
    [_email release];
	_email = nil;
    [_password release];
	_password = nil;
	_delegate = nil;
    [_transactions release];
	_transactions = nil;
	
	[super dealloc];
}

@end
