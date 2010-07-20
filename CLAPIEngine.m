//
//  CLAPIEngine.m
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import "CLAPIEngine.h"
#import "CLUpload.h"

@implementation CLAPIEngine
@synthesize email, password, notificationsEnabled, clearsCookies;

- (NSString *)getAccountInformation {
	
}

- (NSString *)doUpload:(CLUpload *)theUpload {
	
}

- (NSString *)getRecentItemsStartingAtPage:(NSInteger)thePage count:(NSInteger)theCount {
	
}

- (NSString *)getRecentItemsStartingAtPage:(NSInteger)thePage count:(NSInteger)theCount trashedItems:(BOOL)returnTrashedItems {
	
}

- (NSString *)getRecentItemsStartingAtPage:(NSInteger)thePage count:(NSInteger)theCount type:(CLWebItemType)theType trashedItem:(BOOL)returnTrashedItems {
	
}

- (NSString *)getInformationForItemAtShortURL:(NSURL *)shortURL {
	
}

- (NSString *)updateItem {
	
}

- (NSString *)updateAccount {
	
}

- (NSString *)updateAccount:(CLAccount *)theAccount {
	
}

- (NSString *)deleteItem:(CLWebItem *)theItem {
	
}

@end
